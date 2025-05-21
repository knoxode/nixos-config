#!/usr/bin/env bash

# Paths to Hyprland sockets
EVENT_SOCKET="$XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

# Move workspaces 1-5 to eDP-1
move_workspaces_to_edp1() {
  for i in $(seq 1 5); do
    hyprctl keyword unbind "SUPER,$i,exec,~/.config/hypr/startupscripts/2_workspace.sh $i"
    hyprctl dispatch moveworkspacetomonitor "$i" eDP-1
  done
}

# Reset to single monitor configuration
reset_single_monitor() {
  # Move workspaces to eDP-1
  move_workspaces_to_edp1

  # Bind workspaces 1-10 to the internal monitor
  for i in $(seq 1 9); do
    hyprctl dispatch moveworkspacetomonitor "$i" eDP-1
  done
  hyprctl dispatch moveworkspacetomonitor 10 eDP-1

  # Reset binds to single monitor configuration
  for i in $(seq 1 9); do
    hyprctl keyword bind "SUPER, $i, workspace, $i"
  done
  hyprctl keyword bind "SUPER, 0, workspace, 10"
}

# Handle monitor removed events
handle_event() {
  local event="$1"
  case "$event" in
    monitorremoved*)
      local monitor_name=$(echo "$event" | awk -F'>>' '{print $2}' | xargs)
      if [[ "$monitor_name" = "DP-2" ]] || [[ "$monitor_name" = "HDMI-A-1" ]]; then
        echo ""$monitor_name" Removed."
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
