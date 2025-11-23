#!/usr/bin/env bash

# Paths to Hyprland sockets
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

#Move workspaces 1-5 to eDP-1
move_workspaces_to_edp1() {
  for i in $(seq 1 5); do
    hyprctl keyword unbind "SUPER,$i,exec,~/.config/hypr/startupscripts/2_workspace.sh $i"
    hyprctl dispatch moveworkspacetomonitor "$i" eDP-1
  done
}
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
      move_workspaces_to_edp1
      reset_single_monitor
      reload_hyprpanel
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
