#!/usr/bin/env bash
set -euo pipefail

source "$HOME"/.config/monitorHotplug/reconcileMonitors.sh
source "$HOME"/.config/monitorHotplug/handle_monitor_connect.sh
source "$HOME"/.config/monitorHotplug/handle_monitor_disconnect.sh

# -----------------------------------------------------------------------------
# Runtime state / configuration
# -----------------------------------------------------------------------------

EVENT_SOCKET="$XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"
STATE_FILE="$XDG_RUNTIME_DIR/monitorHotplug.state"

DEBOUNCE_NS=500000000 # 500 ms
last_reconcile_ns=0
NOCTALIA_RESTART_LOCK="$XDG_RUNTIME_DIR/noctalia-shell-restarting.lock"

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------

current_boot_id() {
  cat /proc/sys/kernel/random/boot_id
}

restart_noctalia_shell() {
  [[ -e "$NOCTALIA_RESTART_LOCK" ]] && return 0

  if systemctl --user is-active --quiet noctalia-shell.service; then
    echo "[LOG - NOCTALIA]: Scheduling noctalia-shell restart"
    touch "$NOCTALIA_RESTART_LOCK"

    (
      sleep 1
      systemctl --user restart noctalia-shell.service
      sleep 2
      rm -f "$NOCTALIA_RESTART_LOCK"
    ) &
  fi
}

debounce() {
  local now_ns
  now_ns=$(date +%s%N)

  if ((now_ns - last_reconcile_ns < DEBOUNCE_NS)); then
    return 1
  fi

  last_reconcile_ns=$now_ns
  return 0
}

persist_state() {
  {
    echo "BOOT_ID=$(current_boot_id)"
    echo "MONITOR_COUNT=$LAST_MONITOR_COUNT"
    echo "LAST_WORKSPACE=$LAST_WORKSPACE"
    echo "INVOCATION_ID_CACHED=${INVOCATION_ID:-}"
  } >"$STATE_FILE"
}

# -----------------------------------------------------------------------------
# Event handling
# -----------------------------------------------------------------------------

handle_monitor_event() {
  local event="$1"

  [[ -e "$NOCTALIA_RESTART_LOCK" ]] && return 0

  case "$event" in
  monitoraddedv2* | monitorremoved*)
    echo "[LOG - IPC]: IPC Event Detected: $event"

    reconcile_monitors
    echo "[LOG - NOCTALIA]: Restart decision = ${RESTART_NOCTALIA:-0}"

    if debounce && [[ "${RESTART_NOCTALIA:-0}" -eq 1 ]]; then
      restart_noctalia_shell
    fi

    persist_state
    ;;

  reload* | configreloaded*)
    echo "[LOG - IPC]: Hyprland reload detected; reconciling without restart."
    reconcile_monitors
    persist_state
    ;;
  esac
}

# -----------------------------------------------------------------------------
# Initialization
# -----------------------------------------------------------------------------

initJob() {
  local current_boot current_invocation
  current_boot="$(current_boot_id)"
  current_invocation="${INVOCATION_ID:-}"

  LAST_MONITOR_COUNT=""
  LAST_WORKSPACE=""
  USE_CACHED_WORKSPACE=0

  if [[ -f "$STATE_FILE" ]]; then
    # shellcheck disable=SC1090
    source "$STATE_FILE"

    if [[ "${BOOT_ID:-}" == "$current_boot" ]]; then
      LAST_MONITOR_COUNT="${MONITOR_COUNT:-}"

      if [[ -n "${INVOCATION_ID_CACHED:-}" &&
        "${INVOCATION_ID_CACHED}" != "$current_invocation" ]]; then
        # This is a restart, not a fresh start
        USE_CACHED_WORKSPACE=1
        LAST_WORKSPACE="${LAST_WORKSPACE:-}"
        echo "[LOG - INIT] SERVICE RESTART DETECTED — USING CACHED WORKSPACE=$LAST_WORKSPACE"
      else
        echo "[LOG - INIT] FRESH SERVICE START — IGNORING CACHED WORKSPACE"
        LAST_WORKSPACE=""
      fi
    else
      echo "[LOG - INIT] BOOT CHANGED — IGNORING ALL CACHE"
    fi
  else
    echo "[LOG - INIT] NO CACHE FOUND"
  fi

  export LAST_MONITOR_COUNT
  export LAST_WORKSPACE
  export USE_CACHED_WORKSPACE

  reconcile_monitors
  if [[ "${RESTART_NOCTALIA:-0}" -eq 1 ]]; then
    restart_noctalia_shell
  fi
  persist_state
}

# -----------------------------------------------------------------------------
# IPC listener
# -----------------------------------------------------------------------------

hyprland_monitor_event_listener() {
  while true; do
    socat -u UNIX-CONNECT:"$EVENT_SOCKET" - |
      while IFS= read -r event; do
        if ! handle_monitor_event "$event"; then
          echo "[ERROR] Failed to handle event: $event" >&2
        fi
      done

    echo "[LOG - IPC]: HYPR IPC DISCONNECTED, RECONNECTING..."
    sleep 1
  done
}

# -----------------------------------------------------------------------------
# Entrypoint
# -----------------------------------------------------------------------------

main() {
  initJob
  hyprland_monitor_event_listener
}

main
