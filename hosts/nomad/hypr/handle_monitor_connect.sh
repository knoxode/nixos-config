#!/bin/sh

# Paths to Hyprland sockets
EVENT_SOCKET="$XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"
COMMAND_SOCKET="$XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket.sock"

# Directory of the script
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

declare -A MONITOR_RESOLUTIONS
declare -A MONITOR_REFRESH_RATES
declare -A MONITOR_POSITIONS

# Initialize total width to 0
total_width_left=0
total_width_right=0
y_position=0

get_all_monitor_modes() {
    while IFS= read -r line; do
        monitor=$(echo "$line" | cut -d: -f1)
        mode=$(echo "$line" | cut -d: -f2- | xargs)
        resolution=${mode%@*}
        refresh=${mode#*@}

        # Store in associative arrays
        MONITOR_RESOLUTIONS["$monitor"]="$resolution"
        MONITOR_REFRESH_RATES["$monitor"]="$refresh"
    done < <(hyprctl monitors -j | jq -r '.[] | "\(.name): \(.availableModes[0])"')
}

get_all_monitor_modes

# Layout function to stack monitors left and right of eDP-1
arrange_monitors() {
  direction="right"  # Start by placing the first monitor to the right of eDP-1
  eDP_found=false

  for monitor in "${!MONITOR_RESOLUTIONS[@]}"; do
    resolution="${MONITOR_RESOLUTIONS[$monitor]}"  # Get resolution for each monitor
    width=${resolution%x*}  # Extract width (before 'x')
    height=${resolution#*x}  # Extract height (after 'x')

    # If eDP-1 has not been placed, place it at the center (0, 0)
    if [ "$monitor" = "eDP-1" ]; then
      MONITOR_POSITIONS["$monitor"]="0,$y_position"
      total_width_left=0
      total_width_right=0
      eDP_found=true
      continue
    fi

    # For other monitors, place them to the left or right of eDP-1
    if [ "$eDP_found" = true ]; then
      if [ "$direction" = "left" ]; then
        MONITOR_POSITIONS["$monitor"]="-$(($total_width_left + $width)),$y_position"
        total_width_left=$((total_width_left + width))  # Add monitor's width to total width for next monitor
        direction="right"  # After placing left, next should be right
      else
        MONITOR_POSITIONS["$monitor"]="$total_width_right,$y_position"
        total_width_right=$((total_width_right + width))  # Add monitor's width to total width for next monitor
        direction="left"  # After placing right, next should be left
      fi
    fi
  done
}

# Function to configure monitors and apply positions
configure_multiple_monitors() {
  for monitor in "${!MONITOR_POSITIONS[@]}"; do
    position="${MONITOR_POSITIONS[$monitor]}"
    resolution="${MONITOR_RESOLUTIONS[$monitor]}"

    # Format: "x_position y_position resolution"
    echo "Setting $monitor to $position with resolution $resolution"
    # Replace with actual command to apply the position and resolution
    echo "keyword monitor $monitor,$resolution,$position" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"
  done

  # Reload to apply changes
  echo "reload" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"
}
# Function to configure dual-monitor setup
configure_dual_monitor() {

  # Configure DP-2 monitor
  echo "keyword monitor ,3840x2160,0x0,2" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"
  # Configure eDP-1 monitor
  echo "keyword monitor eDP-1,1920x1080,-1920x0,1" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"
  
  # Assign workspaces 1-5 to DP-2
  for i in $(seq 1 5); do
    echo "keyword workspace $i, monitor:DP-5, default:true" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"
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
      if [ "$monitor_name" = "DP-5" ]; then
        configure_dual_monitor
      fi
      ;;
  esac
}

# Listen for events and process them
socat - "UNIX-CONNECT:$EVENT_SOCKET" | while read -r line; do
  handle_event "$line"
done

