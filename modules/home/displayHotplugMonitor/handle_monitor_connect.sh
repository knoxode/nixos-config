#!/usr/bin/env bash

# Function to configure dual-monitor setup
monitor_specific_actions() {
  helper_function() {
    echo "[LOG - GENERAL]: ${external_monitor_model} was detected. Configuring dual monitor.."
    echo "[LOG - GENERAL]: Configuring dual monitor setup...."

    # Configure eDP-1 monitor
    hyprctl keyword monitor eDP-1,preferred,auto-left,1

  }
  prefers_fourkay() {
    # Expected format: WIDTHxHEIGHT@REFRESH
    # Example: 1920x1080@60.00Hz

    local mode height

    mode="${external_monitor_preferred_mode}"

    # Extract HEIGHT:
    # 1) cut at 'x' → 1080@60.00Hz
    # 2) cut at '@' → 1080
    height="$(printf '%s\n' "$mode" | cut -d'x' -f2 | cut -d'@' -f1)"

    # Defensive check
    if [[ -z "$height" || ! "$height" =~ ^[0-9]+$ ]]; then
      echo "[LOG - PREFERS_4K]: Failed to parse height from mode: $mode"
      return 1
    fi

    echo "[LOG - PREFERS_4K]: Detected Resolution is ${height}p."
    if ((height > 1440)); then
      return 0 # true
    else
      return 1 # false
    fi
  }

  if [[ "${external_monitor_model}" == "Monitor TV" ]]; then
    #Configure SPV monitor
    hyprctl keyword monitor "${external_monitor_adapter},highres,auto-up,1"
    helper_function

  elif [[ "${external_monitor_model}" == "DELL P3425WE" ]]; then

    #Configure normal desk monitors
    hyprctl keyword monitor "${external_monitor_adapter},highrr,auto,1"
    helper_function
  else
    #Configure normal desk monitors
    if prefers_fourkay; then
      hyprctl keyword monitor "${external_monitor_adapter},preferred,auto,1.5"
      helper_function
    else
      hyprctl keyword monitor "${external_monitor_adapter},preferred,auto,1"
      helper_function
    fi
  fi

}

# monitor_probe() {
#
# }

generic_dual_mon_helper() {
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
    echo "[LOG - DUAL MONITOR]: Removed single monitor keybind $i."
  done
  hyprctl keyword unbind "SUPER, 0, workspace, 10"
  echo "[LOG - DUAL MONITOR]: Removed single monitor keybind 10."

  # Update binds for dual-monitor configuration (moving to both workspace 1 and 6, etc.)
  for i in $(seq 1 5); do
    hyprctl keyword bind "SUPER, $i, exec, bash ~/.config/hypr/startupscripts/2_workspace.sh $i"
    echo "[LOG - DUAL MONITOR]: Added dual-monitor keybind $i."
  done
}

dual_monitor_setup() {
  monitor_specific_actions
  # monitor_probe
  generic_dual_mon_helper
  restart_noctalia_shell
}
