#!/usr/bin/env bash
# Select the WireGuard outer-transport endpoint.
#
# Preference order is IPv6, then IPv4. A candidate is only used when the
# marked route (the same path WireGuard's outer packets take) leaves through
# a real underlay and a WireGuard handshake succeeds. A failed IPv6 attempt
# is held down so a flaky IPv6 path cannot flap the tunnel.
#
# Environment (set by the NixOS module):
#   WG_IFACE WG_PEER WG_HOSTNAME WG_PORT WG_FW_MARK WG_PSK_FILE
#   WG_ALLOWED_IPS WG_KEEPALIVE WG_PROBE_IP WG_STATE_DIR
#   WG_HANDSHAKE_MAX_AGE WG_V6_HOLD_SECONDS

state_dir="${WG_STATE_DIR:-/run/wireguard-endpoint}"
state_file="${state_dir}/v6-hold-until"
lock_file="${state_dir}/lock"
reset_flag="${state_dir}/reset-hold"

log() {
  printf 'wg-endpoint: %s\n' "$*" >&2
}

now() {
  date +%s
}

is_v6_addr() {
  [[ "$1" == *:* ]]
}

is_v6_endpoint() {
  [[ "$1" == \[* ]]
}

endpoint_addr() {
  local endpoint="$1"

  if [[ "$endpoint" == \[* ]]; then
    endpoint="${endpoint#\[}"
    printf '%s' "${endpoint%%\]*}"
  else
    printf '%s' "${endpoint%:*}"
  fi
}

fmt_endpoint() {
  local addr="$1"

  if is_v6_addr "$addr"; then
    printf '[%s]:%s' "$addr" "$WG_PORT"
  else
    printf '%s:%s' "$addr" "$WG_PORT"
  fi
}

resolve_addr() {
  local family="$1"
  local addr=""

  if [ "$family" = 6 ]; then
    addr="$(timeout 5 getent ahostsv6 "$WG_HOSTNAME" 2>/dev/null | awk 'NF { print $1; exit }')" || true
  else
    addr="$(timeout 5 getent ahostsv4 "$WG_HOSTNAME" 2>/dev/null | awk 'NF { print $1; exit }')" || true
  fi

  printf '%s' "$addr"
}

current_endpoint() {
  wg show "$WG_IFACE" endpoints 2>/dev/null |
    awk -v peer="$WG_PEER" '$1 == peer { print $2; exit }' || true
}

handshake_time() {
  wg show "$WG_IFACE" latest-handshakes 2>/dev/null |
    awk -v peer="$WG_PEER" '$1 == peer { print $2; exit }' || true
}

route_viable() {
  local addr="$1"
  local family="-4"
  local out=""
  local dev=""
  local src=""

  if is_v6_addr "$addr"; then
    family="-6"
  fi

  if ! out="$(ip "$family" route get mark "$WG_FW_MARK" to "$addr" 2>/dev/null)"; then
    return 1
  fi

  dev="$(awk '{ for (i = 1; i <= NF; i++) if ($i == "dev") { print $(i + 1); exit } }' <<<"$out")"
  src="$(awk '{ for (i = 1; i <= NF; i++) if ($i == "src") { print $(i + 1); exit } }' <<<"$out")"

  [ -n "$dev" ] || return 1
  [ -n "$src" ] || return 1
  [ "$dev" != "$WG_IFACE" ] || return 1
  [ "$dev" != "lo" ] || return 1
  ip link show dev "$dev" 2>/dev/null | grep -q '<[^>]*UP' || return 1

  if is_v6_addr "$addr"; then
    [ "$src" != "::" ] || return 1
    [[ "$src" != fe80:* ]] || return 1
  else
    [ "$src" != "0.0.0.0" ] || return 1
  fi

  return 0
}

load_hold() {
  local value=""

  if [ -r "$state_file" ]; then
    value="$(cat "$state_file" 2>/dev/null || true)"
    case "$value" in
      '' | *[!0-9]*) value=0 ;;
    esac
  else
    value=0
  fi

  printf '%s' "$value"
}

save_hold() {
  printf '%s\n' "$1" >"$state_file"
}

remove_peer() {
  wg set "$WG_IFACE" peer "$WG_PEER" remove >/dev/null 2>&1 || true
}

add_peer() {
  local endpoint="$1"

  wg set "$WG_IFACE" peer "$WG_PEER" \
    preshared-key "$WG_PSK_FILE" \
    endpoint "$endpoint" \
    persistent-keepalive "$WG_KEEPALIVE" \
    allowed-ips "$WG_ALLOWED_IPS"
}

# Reset the session before probing. If a still-valid session were left in
# place, WireGuard would keep using it and a broken candidate could look
# unchanged because no new handshake is attempted.
probe_candidate() {
  local endpoint="$1"
  local hs_before=""
  local hs=""
  local i=0

  remove_peer
  hs_before="$(handshake_time)"
  [ -n "$hs_before" ] || hs_before=0

  if ! add_peer "$endpoint"; then
    log "failed to install endpoint $endpoint"
    return 1
  fi

  ping -c1 -W1 -n "$WG_PROBE_IP" >/dev/null 2>&1 || true

  while [ "$i" -lt 60 ]; do
    hs="$(handshake_time)"
    if [ -n "$hs" ] && [ "$hs" -gt 0 ] && [ "$hs" -gt "$hs_before" ]; then
      return 0
    fi
    sleep 0.1
    i=$((i + 1))
  done

  return 1
}

main() {
  local reset_hold=0
  local hold_until=0
  local now_ts=0
  local current=""
  local current_addr=""
  local hs=""
  local current_ok=0
  local current_healthy=0
  local need_select=0
  local aaaa=""
  local a=""
  local selected=""
  local cand=""
  local candidates=()

  while [ "$#" -gt 0 ]; do
    case "$1" in
      --reset-hold) reset_hold=1 ;;
      *) log "unknown argument: $1" ;;
    esac
    shift
  done

  if ! ip link show dev "$WG_IFACE" >/dev/null 2>&1; then
    log "interface $WG_IFACE is not present"
    return 0
  fi

  mkdir -p "$state_dir"
  exec 9>"$lock_file"
  if ! flock -w 30 9; then
    log "another endpoint selection is running; skipping"
    return 0
  fi

  if [ ! -r "$WG_PSK_FILE" ]; then
    log "preshared key $WG_PSK_FILE is not readable"
    return 1
  fi

  hold_until="$(load_hold)"
  if [ "$reset_hold" = 1 ] || [ -e "$reset_flag" ]; then
    hold_until=0
    rm -f "$reset_flag"
    save_hold "$hold_until"
    log "cleared IPv6 hold-down"
  fi

  now_ts="$(now)"
  current="$(current_endpoint)"
  case "$current" in
    '' | '(none)' | off) current="" ;;
  esac

  if [ -n "$current" ]; then
    current_addr="$(endpoint_addr "$current")"
    if route_viable "$current_addr"; then
      current_ok=1
    fi

    hs="$(handshake_time)"
    if [ "$current_ok" = 1 ] && [ -n "$hs" ] && [ "$hs" -gt 0 ] &&
      [ "$((now_ts - hs))" -le "$WG_HANDSHAKE_MAX_AGE" ]; then
      current_healthy=1
    fi
  fi

  if [ "$current_healthy" = 0 ]; then
    need_select=1
  fi

  aaaa="$(resolve_addr 6)"
  a="$(resolve_addr 4)"

  # A healthy IPv4 endpoint is upgraded once IPv6 becomes viable. This is the
  # only case where a healthy endpoint is changed; a failed attempt sets the
  # hold-down below.
  if [ "$need_select" = 0 ] && [ -n "$current" ] &&
    ! is_v6_endpoint "$current" && [ "$now_ts" -ge "$hold_until" ] &&
    [ -n "$aaaa" ] && route_viable "$aaaa"; then
    need_select=1
  fi

  if [ "$need_select" = 0 ]; then
    log "keeping healthy endpoint $current"
    return 0
  fi

  if [ -n "$aaaa" ] && [ "$now_ts" -ge "$hold_until" ] &&
    route_viable "$aaaa"; then
    candidates+=("$(fmt_endpoint "$aaaa")")
  fi

  if [ -n "$a" ] && route_viable "$a"; then
    candidates+=("$(fmt_endpoint "$a")")
  fi

  if [ "${#candidates[@]}" -eq 0 ]; then
    log "no viable endpoint candidates (IPv6=${aaaa:-none}, IPv4=${a:-none})"
    return 0
  fi

  for cand in "${candidates[@]}"; do
    log "trying $cand"
    if probe_candidate "$cand"; then
      selected="$cand"
      break
    fi

    log "candidate $cand failed"
    if is_v6_endpoint "$cand"; then
      hold_until="$(($(now) + WG_V6_HOLD_SECONDS))"
      save_hold "$hold_until"
      log "holding IPv6 until $hold_until"
    fi
  done

  if [ -n "$selected" ]; then
    if is_v6_endpoint "$selected"; then
      hold_until=0
      save_hold "$hold_until"
    fi
    log "selected $selected"
    return 0
  fi

  if [ -n "$current" ]; then
    log "all candidates failed; restoring $current"
    add_peer "$current" || true
  else
    log "all candidates failed; no previous endpoint to restore"
  fi

  return 1
}

main "$@"
