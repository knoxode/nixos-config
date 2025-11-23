#!/usr/bin/env bash
EVENT_SOCKET="$XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

reload_hyprpanel() {
  local pid
  pid=$(pgrep hyprpanel)

  if [[ -n "$pid" ]]; then
    kill "$pid" 2>/dev/null || kill -9 "$pid"
    sleep 0.5
  fi

  nohup hyprpanel >/dev/null 2>&1 &
}

# Function to configure dual-monitor setup
configure_dual_monitor() {

  if [[ "${external_monitor_model}" != "Monitor TV" ]]; then
    #Configure normal desk monitors
    hyprctl monitor "${external_monitor_adapter},preferred,auto,1"

    echo "${external_monitor_adapter} was detected. Configuring dual monitor."
    echo "Configuring dual monitor setup..."

    # Configure eDP-1 monitor
    hyprctl keyword monitor eDP-1,preferred,auto-left,1

  else
    #Configure SPV monitor
    hyprctl monitor "${external_monitor_adapter},highres,auto-up,1"

    echo "${external_monitor_adapter} was detected. Configuring dual monitor."
    echo "Configuring dual monitor setup..."

    # Configure eDP-1 monitor
    hyprctl keyword monitor eDP-1,preferred,auto,1
  fi

  # Move workspaces 1-5 to DP-2
  for i in $(seq 1 5); do
    hyprctl dispatch moveworkspacetomonitor "$i" "$external_monitor_adapter"
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

  #Checking explicitly for external monitors, so case will always be dual monitor (or more, but implemented here)
  case "$event" in
  monitoraddedv2*)
    external_monitor_adapter=$(hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1") | .name' | xargs)
    external_monitor_model=$(hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1") | .model' | xargs)

    #Configure the dual-monitor setup
    configure_dual_monitor
    reload_hyprpanel
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
