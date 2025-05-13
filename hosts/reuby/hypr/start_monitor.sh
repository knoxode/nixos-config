#!/usr/bin/env bash

# Paths to Hyprland sockets
COMMAND_SOCKET="$XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket.sock"

# Function to configure for a single monitor setup

# Function to configure for a dual monitor setup
configure_dual_monitor() {
    external_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1") | .name')
    
    echo "Configuring dual monitor setup..."

    # Set up monitor DP-2
    echo "keyword monitor $external_monitor,2560x1440,0x0,1" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"

    # Set up monitor eDP-1
    echo "keyword monitor eDP-1,1920x1080,-1920x0,1" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"

    # Assign workspaces 1-5 to DP-2 and 6-10 to eDP-1
    for i in $(seq 1 5); do
        echo "keyword workspace $i, monitor:$external_monitor, default:true" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"
    done
    for i in $(seq 6 10); do
        echo "keyword workspace $i, monitor:eDP-1, default:true" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"
    done

    # Set up keybinds to switch workspaces on both monitors
    for i in $(seq 1 5); do
        echo "keyword bind \$mainMod, $i, exec, ~/.config/hypr/2_workspace.sh $i" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"
    done
    hyprpanel -q && hyprpanel
}

# Main function to determine monitor setup and configure accordingly
main() {
    # Count connected monitors
    num_monitors=$(hyprctl monitors -j | jq '. | length')

    if [ "$num_monitors" -eq 2 ]; then
        configure_dual_monitor
    else
      echo "Single monitor detected. Not changing config."
      hyprpanel -q && hyprpanel
    fi
}

# Run the script
main

