#!/usr/bin/env bash
set -euo pipefail

source "$HOME"/.config/monitorHotplug/handle_monitor_connect.sh
source "$HOME"/.config/monitorHotplug/handle_monitor_disconnect.sh

# initialize Important variables
EVENT_SOCKET="$XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"
DEBOUNCE_NS=500000000 # 500 ms
last_reconcile_ns=0
external_monitor_adapter=""
external_monitor_model=""
external_monitor_preferred_mode=""
NOCTALIA_RESTART_LOCK="$XDG_RUNTIME_DIR/noctalia-shell-restarting.lock"

restart_noctalia_shell() {
  # If already restarting, do nothing
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

# Reconcile monitor state based on *current* reality
reconcile_monitors() {
  local num_monitors
  num_monitors=$(hyprctl monitors -j | jq length)

  # If Dual Monitor - then start dual monitor function.
  if ((num_monitors > 1)); then
    external_monitor_adapter=$(hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1") | .name' | xargs)
    external_monitor_model=$(hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1") | .model' | xargs)
    external_monitor_preferred_mode=$(hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1") | .availableModes[0]' | xargs)
    echo "[LOG - EXT. MON. FT. DETECT]: Detected Preferred Mode: ${external_monitor_preferred_mode}."
    export external_monitor_adapter
    export external_monitor_model
    export external_monitor_preferred_mode

    dual_monitor_setup
  else
    # Do functions related to single monitor (dynamic, not init)
    single_monitor_setup
  fi
}

debounce() {
  local now_ns
  now_ns=$(date +%s%N)

  if ((now_ns - last_reconcile_ns < DEBOUNCE_NS)); then
    return 1 # too soon
  fi

  last_reconcile_ns=$now_ns
  return 0
}

# Handle *any* monitor-related event by reconciling state
handle_monitor_event() {
  local event="$1"

  [[ -e "$NOCTALIA_RESTART_LOCK" ]] && return 0

  case "$event" in
  monitoraddedv2* | monitorremoved*)
    debounce || return 0
    reconcile_monitors
    ;;
  esac
}

initJob() {
  reconcile_monitors
}

hyprland_monitor_event_listener() {
  while true; do
    socat -u UNIX-CONNECT:"$EVENT_SOCKET" - |
      while IFS= read -r event; do
        handle_monitor_event "$event"
      done || true # <-- critical

    echo "[LOG - IPC]: Hyprland IPC disconnected, reconnecting..."
    sleep 1
  done
}

main() {
  initJob
  hyprland_monitor_event_listener
}

main
