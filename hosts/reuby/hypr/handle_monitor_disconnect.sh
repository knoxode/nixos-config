#!/usr/bin/env bash

# Paths to Hyprland sockets
EVENT_SOCKET="$XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"
COMMAND_SOCKET="$XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket.sock"

echo "Running as: $(whoami)"
printf "\n"
echo "UID: $(id -u)"
printf "\n"
echo "HOME: $HOME"
printf "\n"
env >&2  # Dumps all environment variables to stderr (i.e., to your log)
printf "\n"
echo "Checking for socket 1: $XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket.sock"
printf "\n"
echo "Checking for socket 2: $XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

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
}

# Handle monitor removed events
handle_event() {
  local event="$1"
  case "$event" in
    monitorremoved*)
      local monitor_name=$(echo "$event" | awk -F'>>' '{print $2}' | xargs)
      if [ "$monitor_name" = "DP-2" ]; then
        reset_single_monitor
      fi
      ;;
  esac
}

# Wait until both Hyprland sockets exist
while [ ! -S "$COMMAND_SOCKET" ] && [ ! -S "$EVENT_SOCKET" ]; do
    echo "Waiting for Hyprland sockets to appear..."
    sleep 0.5
done

# Listen for events and process them
while true; do
  socat - "UNIX-CONNECT:$EVENT_SOCKET" | while read -r line; do
    handle_event "$line"
  done
done

echo "Exiting..."
