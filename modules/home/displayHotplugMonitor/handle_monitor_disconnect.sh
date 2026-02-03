#!/usr/bin/env bash
#Move workspaces 1-5 to eDP-1
handle_keybinds_single_mon() {
  # Resets silent move-to-workspace binds to single monitor
  for i in $(seq 1 5); do
    hyprctl keyword unbind "SUPER,$i,exec,~/.config/hypr/startupscripts/2_workspace.sh $i"
    echo "[LOG - SINGLE MON KEYBIND HELPER]: UNSET 2_workspace.sh keybindings."
    hyprctl dispatch moveworkspacetomonitor "$i" eDP-1
  done

  for i in $(seq 6 10); do
    hyprctl dispatch moveworkspacetomonitor "$i" "eDP-1"
  done
  echo "[LOG - SINGLE MON HELPER]: SET all workspace ownership to eDP-1."

  for i in $(seq 1 9); do
    hyprctl keyword bind "SUPER, $i, workspace, $i"
  done
  hyprctl keyword bind "SUPER, 0, workspace, 10"
  echo "[LOG - SINGLE MON HELPER]: SET workspace keybindings to SUPER+X."
}

# Reset to single monitor configuration
single_monitor_setup() {
  handle_keybinds_single_mon
  # Configure eDP-1 monitor
  hyprctl keyword monitor eDP-1,preferred,auto,1
  echo "[LOG - SINGLE MONITOR]: Reset Display Resolution, Placement and Refresh Rate."
  restart_noctalia_shell
}
