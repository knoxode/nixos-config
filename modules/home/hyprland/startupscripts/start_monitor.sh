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
}

# Function to configure for a single monitor setup
configure_single_monitor() {
  hyprctl keyword monitor "eDP-1,preferred,auto,1"
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
