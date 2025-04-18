#!/usr/bin/env bash
while ! pgrep Hyprland >/dev/null; do
  sleep 1
done

######################################################
#                      SET PATHS                     #
######################################################

# Paths to Hyprland sockets
EVENT_SOCKET="$XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"
COMMAND_SOCKET="$XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket.sock"

INTEL_CARD=$(readlink -f /dev/dri/by-path/*-card | head -n 1)
NVIDIA_CARD=$(readlink -f /dev/dri/by-path/*-card | tail -n 1)

CONFIG_RELOAD_DONE=False
MONITOR_INFO_STORE=/home/shaiikura/.hypr/monitor_info.json

#If the monitor_info file doesn't exist, make it.
if [[ ! -e "$MONITOR_INFO_STORE" ]]; then
  touch MONITOR_INFO_STORE
fi

######################################################
#            DEFINE ESSENTIAL FUNCTIONS              #
######################################################

# Function to collect added monitor information
collect_added_monitor_info() {
  local event="$1"
  ADDEDMONITORID=$(echo "$event" | awk -F',' '{print $1}')
  ADDEDMONITORNAME=$(echo "$event" | awk -F',' '{print $2}')
  ADDEDMONITORDESCRIPTION=$(echo "$event" | awk -F',' '{print $3}')
  readarray -t connected_monitors < <(hyprctl monitors -j | jq -r '.[].name')
  num_monitors=${#connected_monitors[@]}
}

# Function to collect added monitor information
collect_removed_monitor_info() {
  local event="$1"
  REMOVEDMONITORNAME=$(echo "$event" | awk -F',' '{print $1}')
  readarray -t connected_monitors < <(hyprctl monitors -j | jq -r '.[].name')
  num_monitors=${#connected_monitors[@]}
}

file_check(){}

file_read(){

}

file_write(){

}

single_monitor(){

}

######################################################
#                    FINAL STAGE                     #
#               EXECUTION FUNCTIONS                  #
######################################################

startup_function(){
  #If the MONITOR_INFO_STORE file is empty, then fill it with the current monitor information.
  if [ ! -s "$MONITOR_INFO_STORE" ]; then
    hyprctl monitors -j | jq '[.[] | {id, name, description, model, favouredMode: .availableModes[0], width, height, refreshRate, x, y, scale, lastid, lastMode, lastwidth, lastheight, lastRefreshRate, lastx, lasty, lastscale}]' > $MONITOR_INFO_STORE
  fi

  readarray -t connected_monitors < <(hyprctl monitors -j | jq -r '.[].name')
  num_monitors=${#connected_monitors[@]}
}

startup_function

#Essentially the first node in the flow control scheme after an event is triggered
#Only listening to the three events I care about.
handle_events() {
  case $1 in
    monitoraddedv2*)
      collect_added_monitor_info "$1"
      ;;
    monitorremoved*)
      collect_removed_monitor_info "$1"
      ;;
    configreloaded*)
      $CONFIG_RELOAD_DONE=True
      ;;
    moveworkspace*)
      $CONFIG_RELOAD_DONE=True
      ;;
  esac
}

# Listen for events and process them
socat - "UNIX-CONNECT:$EVENT_SOCKET" | while read -r line; do
  handle_events "$line"
done
