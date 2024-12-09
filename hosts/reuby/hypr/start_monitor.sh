#!/bin/bash

# Paths to Hyprland sockets
COMMAND_SOCKET="$XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket.sock"

# Function to configure for a single monitor setup
configure_single_monitor() {
    echo "Configuring single monitor setup..."

    # Set up monitor eDP-1
    echo "keyword monitor eDP-1,1920x1080,0x0,1" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"

    # Assign workspaces 1-10 to eDP-1
    for i in $(seq 1 10); do
        echo "keyword workspace $i, monitor:eDP-1, default:true" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"
    done

    # Set up keybinds for workspaces 1-10
    for i in $(seq 1 10); do
        echo "keyword bind \$mainMod, $i, workspace, $i" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"
    done
}

# Function to configure for a dual monitor setup
configure_dual_monitor() {
    echo "Configuring dual monitor setup..."

    # Set up monitor DP-2
    echo "keyword monitor DP-2,2560x1440,0x0,1" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"

    # Set up monitor eDP-1
    echo "keyword monitor eDP-1,1920x1080,-1920x0,1" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"

    # Assign workspaces 1-5 to DP-2 and 6-10 to eDP-1
    for i in $(seq 1 5); do
        echo "keyword workspace $i, monitor:DP-2, default:true" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"
    done
    for i in $(seq 6 10); do
        echo "keyword workspace $i, monitor:eDP-1, default:true" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"
    done

    # Set up keybinds to switch workspaces on both monitors
    for i in $(seq 1 5); do
        echo "keyword bind \$mainMod, $i, exec, ~/.config/hypr/2_workspace.sh $i" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"
    done
}

# Main function to determine monitor setup and configure accordingly
main() {
    # Count connected monitors
    num_monitors=$(hyprctl monitors -j | jq '. | length')

    if [ "$num_monitors" -eq 2 ]; then
        configure_dual_monitor
    else
        configure_single_monitor
    fi
}

# Run the script
main

