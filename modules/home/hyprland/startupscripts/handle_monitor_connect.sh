#!/usr/bin/env bash
EVENT_SOCKET="$XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

# Function to configure dual-monitor setup
configure_dual_monitor() {

  # Configure DP-2 monitor
  hyprctl monitor $external_monitor,preferred,auto,1
  
  echo ""$external_monitor" was detected. Configuring dual monitor."
  echo "Configuring dual monitor setup..."
  
  # Configure eDP-1 monitor
  hyprctl keyword monitor eDP-1,1920x1080,auto-left,1
  
  # Move workspaces 1-5 to DP-2
  for i in $(seq 1 5); do
   hyprctl dispatch moveworkspacetomonitor "$i" "$external_monitor"
  done

  # Move workspaces 6-10 to eDP-1
  for i in $(seq 6 10); do
    hyprctl dispatch moveworkspacetomonitor "$i" eDP-1
  done

  #Remove stale keybinds 1-10 that only move to one workspace at a time
  for i in $(seq 1 9); do
    hyprctl keyword unbind "SUPER, $i, workspace, $i"
    echo "Removed single monitor keybind $i"
  done
  
  hyprctl keyword unbind "SUPER, 0, workspace, 10"
  
  # Update binds for dual-monitor configuration (moving to both workspace 1 and 6, etc.)
  for i in $(seq 1 5); do
    hyprctl keyword bind "SUPER, $i, exec, ~/.config/hypr/startupscripts/2_workspace.sh $i"
    echo "Added dual-monitor keybind $i"
  done
}

# Function to handle monitor added events
handle_event() {
  local event="$1"

  case "$event" in
    monitoraddedv2*)
      # Extract the monitor name from the event
      local monitor_info=$(echo "$event" | awk -F'>>' '{print $2}')
      external_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1") | .name' | xargs)

      # If the added monitor is DP-2, configure the dual-monitor setup
      if [[ "$external_monitor" = "DP-2" ]] || [[ "$external_monitor" = "HDMI-A-1" ]]; then
        echo "$external_monitor Connected."
        configure_dual_monitor
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
