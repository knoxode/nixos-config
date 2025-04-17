#!/bin/sh

# Paths to Hyprland sockets
COMMAND_SOCKET="$XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket.sock"


INTEL_CARD=$(readlink -f /dev/dri/by-path/*-card | head -n 1)
NVIDIA_CARD=$(readlink -f /dev/dri/by-path/*-card | tail -n 1)

# Function to configure for a single monitor setup
configure_single_monitor() {
    echo "Configuring single monitor setup..."

    # Set up monitor eDP-1
    echo "keyword monitor eDP-1,1920x1080@144,0x0,1" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"

    # Assign workspaces 1-10 to eDP-1
    for i in $(seq 1 9); do
        echo "keyword workspace $i, monitor:eDP-1, default:true" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"
    done

    echo "keyword workspace 10, monitor:eDP-1, default:true" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"


    # Set up keybinds for workspaces 1-10
    for i in $(seq 1 9); do
        echo "keyword bind \$mainMod, $i, workspace, $i" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"
    done
    
    echo "keyword bind \$mainMod, 0, workspace, 10" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"
}

# Function to configure for a dual monitor setup
configure_dual_monitor() {
    
    external_monitor="$1"

    export AQ_DRM_DEVICS="${NVIDIA_CARD}":"${INTEL_CARD}"

    echo "Configuring dual monitor setup..."

    # Set up monitor DP-2
    echo "keyword monitor $external_monitor,3840x2160,0x0,2" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"

    # Set up monitor eDP-1
    echo "keyword monitor eDP-1,1920x1080@144,-1920x0,1" | socat - "UNIX-CONNECT:$COMMAND_SOCKET"

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
}

detect_external_monitor() {
    hyprctl monitors -j | jq -r '.[] | select(.name | test("^eDP") | not) | .name'
}

# Main function to determine monitor setup and configure accordingly
main() {
    # Count connected monitors
    num_monitors=$(hyprctl monitors -j | jq '. | length')
    external=$(detect_external_monitor)

    if [ "$num_monitors" -eq 2 ]; then
        if [ -n "$external" ]; then
          configure_dual_monitor "$external"
        else
          echo "Could not detect external monitor, failing back to single monitor configuration."
        fi
    else
        configure_single_monitor
    fi
}

# Run the script
main

