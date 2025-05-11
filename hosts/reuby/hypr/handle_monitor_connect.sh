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

# Function to configure dual-monitor setup
configure_dual_monitor() {

  echo "reload" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"
  # Configure DP-2 monitor
  echo "keyword monitor DP-2,2560x1440,0x0,1" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"
  # Configure eDP-1 monitor
  echo "keyword monitor eDP-1,1920x1080,-1920x0,1" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"
  
  # Assign workspaces 1-5 to DP-2
  for i in $(seq 1 5); do
    echo "keyword workspace $i, monitor:DP-2, default:true" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"
  done

  # Assign workspaces 6-10 to eDP-1
  for i in $(seq 6 10); do
    echo "keyword workspace $i, monitor:eDP-1, default:true" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"
  done

  # Update binds for dual-monitor configuration
  for i in $(seq 1 5); do
    echo "keyword bind \$mainMod, $i, exec, 2_workspace.sh $i" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"
  done
}

# Function to handle monitor added events
handle_event() {
  local event="$1"

  case "$event" in
    monitoraddedv2*)
      # Extract the monitor name from the event
      local monitor_info=$(echo "$event" | awk -F'>>' '{print $2}')
      local monitor_name=$(echo "$monitor_info" | awk -F',' '{print $2}' | xargs)

      # If the added monitor is DP-2, configure the dual-monitor setup
      if [ "$monitor_name" = "DP-2" ]; then
        configure_dual_monitor
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
