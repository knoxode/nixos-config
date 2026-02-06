#!/usr/bin/env bash
set -uo pipefail

MAX_WAIT_MS=30000
INTERVAL_MS=500

ACTION="${1:-}"
VALUE="${2:-}"

error() {
  echo "[ERROR: Safe DDC Exec]: $*" >&2
  exit 1
}

log() {
  echo "[LOG: Safe DDC Exec]: $*"
}

warn() {
  echo "[WARN: Safe DDC Exec]: $*"
}

wait_for_outputs() {
  local elapsed=0
  local stable_ms=0
  local last_state=""
  local curr_state=""

  log "Waiting for Hyprland outputs to stabilise"

  while ((elapsed < MAX_WAIT_MS)); do
    curr_state="$(hyprctl monitors -j 2>/dev/null || true)"

    if [[ -n "$curr_state" ]]; then
      # Require at least one non-eDP output
      if echo "$curr_state" | grep -q '"name": "[^"]*-'; then
        if [[ "$curr_state" == "$last_state" ]]; then
          ((stable_ms += INTERVAL_MS))
          if ((stable_ms >= 2000)); then
            log "Hyprland outputs stable"
            return 0
          fi
        else
          stable_ms=0
          last_state="$curr_state"
        fi
      fi
    fi

    sleep 0.5
    ((elapsed += INTERVAL_MS))
  done

  warn "Outputs never stabilised, skipping DDC"
  return 1
}

get_valid_ddc_buses() {
  ddcutil detect 2>/dev/null |
    awk '
        /^Display [0-9]+/ { valid=1 }
        /^Invalid display/ { valid=0 }
        valid && /I2C bus:/ { gsub(".*/dev/i2c-","",$NF); print $NF }
      '
}

run_ddc_all() {
  local value="$1"
  local buses

  mapfile -t buses < <(get_valid_ddc_buses)

  if ((${#buses[@]} == 0)); then
    log "No valid DDC displays detected"
    return 0
  fi

  for bus in "${buses[@]}"; do
    log "Setting brightness to ${value} on i2c bus ${bus}"
    ddcutil --bus="$bus" setvcp 10 "$value" ||
      log "DDC failed on bus ${bus}, continuing"
  done
}

case "$ACTION" in
up)
  TARGET=100
  ;;
down)
  TARGET=10
  ;;
set)
  [[ -n "$VALUE" ]] || error "set requires a value"
  TARGET="$VALUE"
  ;;
*)
  error "Usage: $0 {up|down|set <value>}"
  ;;
esac

wait_for_outputs || exit 0

sleep 1 # final settle delay

run_ddc_all "$TARGET"
