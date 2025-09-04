#!/usr/bin/env bash

# Function to configure for a dual monitor setup
configure_dual_monitor() {
  external_monitor_adapter=$(hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1") | .name')
  external_monitor_model=$(hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1") | .model')

  echo "Detected external monitor: ${external_monitor_adapter} (${external_monitor_model})"

  if [[ "$external_monitor_model" == "Monitor TV" ]]; then
    echo "Configuring SPV TV setup..."
    hyprctl keyword monitor "${external_monitor_adapter},highres,auto-up,1"
    hyprctl keyword monitor "eDP-1,preferred,auto,1"
  else
    echo "Configuring normal dual monitor setup..."
    hyprctl keyword monitor "${external_monitor_adapter},preferred,auto,1"
    hyprctl keyword monitor "eDP-1,preferred,auto-left,1"
  fi

  # Move workspaces 1–5 to external monitor, 6–10 to laptop
  for i in $(seq 1 5); do
    hyprctl dispatch moveworkspacetomonitor "$i" "$external_monitor_adapter"
  done
  for i in $(seq 6 10); do
    hyprctl dispatch moveworkspacetomonitor "$i" "eDP-1"
  done

  # Set up keybinds to use external script for switching
  for i in $(seq 1 5); do
    hyprctl keyword bind "SUPER, $i, exec, ~/.config/hypr/startupscripts/2_workspace.sh $i"
  done
}

# Function to configure for a single monitor setup
configure_single_monitor() {
  echo "Single monitor detected. Configuring..."
  hyprctl keyword monitor "eDP-1,preferred,auto,1"

  # Assign workspaces 1–10 to eDP-1
  for i in $(seq 1 10); do
    hyprctl dispatch moveworkspacetomonitor "$i" "eDP-1"
  done

  # Reset binds to standard single monitor switching
  for i in $(seq 1 9); do
    hyprctl keyword bind "SUPER, $i, workspace, $i"
  done
  hyprctl keyword bind "SUPER, 0, workspace, 10"
}

# Main function to determine monitor setup and configure accordingly
main() {

  num_monitors=$(hyprctl monitors -j | jq '. | length')

  if [ "$num_monitors" -eq 2 ]; then
    configure_dual_monitor
  else
    configure_single_monitor
  fi
}

main
