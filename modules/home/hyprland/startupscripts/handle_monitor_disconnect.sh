#!/usr/bin/env bash

# Paths to Hyprland sockets
EVENT_SOCKET="$XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

# Reset to single monitor configuration
reset_single_monitor() {
  # Configure eDP-1 monitor
  hyprctl keyword monitor eDP-1,preferred,auto,1
}

# Handle monitor removed events
handle_event() {
  local event="$1"
  case "$event" in
  monitorremoved*)
    local monitor_name=$(echo "$event" | awk -F'>>' '{print $2}' | xargs)
    if [[ "$monitor_name" = "DP-2" ]] || [[ "$monitor_name" = "HDMI-A-1" ]]; then
      echo "${monitor_name} Removed."
      reset_single_monitor
    fi
    ;;
  esac
}

# Listen for events and process them
while true; do
  socat - "UNIX-CONNECT:$EVENT_SOCKET" | while read -r line; do
    handle_event "$line"
  done
done

echo "Exiting..."
