#!/bin/sh

# Paths to Hyprland sockets
EVENT_SOCKET="$XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"
COMMAND_SOCKET="$XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket.sock"

# Move workspaces 1-5 to eDP-1
move_workspaces_to_edp1() {
  for i in $(seq 1 5); do
    hyprctl dispatch moveworkspacetomonitor $i eDP-1
  done
}

# Reset to single monitor configuration
reset_single_monitor() {
  # Move workspaces to eDP-1
  move_workspaces_to_edp1

  echo "keyword env AQ_DRM_DEVICES,/dev/dri/card0"

  # Reload configuration
  echo "reload" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"

  # Bind workspaces 1-10 to the internal monitor
  for i in $(seq 1 9); do
    echo "keyword workspace $i, monitor:eDP-1, default:true" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"
  done
  echo "keyword workspace 10, monitor:eDP-1, default:true" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"

  # Reset binds to single monitor configuration
  for i in $(seq 1 9); do
    echo "keyword bind \$mainMod, $i, workspace, $i" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"
  done
  echo "keyword bind \$mainMod, 0, workspace, 10" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"

  sleep 1
  hyprpanel -q && hyprpanel
}

# Handle monitor removed events
handle_event() {
  local event="$1"
  case "$event" in
    monitorremoved*)
      local monitor_name=$(echo "$event" | awk -F'>>' '{print $2}' | xargs)
      if [ "$monitor_name" = "DP-2" || "$monitor_name" = "HDMI-A-1" ]; then
        reset_single_monitor
      fi
      ;;
  esac
}

# Listen for events and process them
socat - "UNIX-CONNECT:$EVENT_SOCKET" | while read -r line; do
  handle_event "$line"
done

