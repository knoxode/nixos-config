#!/usr/bin/env bash
set +e

# ------------------------------------------------------------------
# Batch builder helpers
# ------------------------------------------------------------------
BATCH_CMDS=""

batch() {
  BATCH_CMDS+="$1;"
}

commit_batch() {
  [[ -z "$BATCH_CMDS" ]] && return 0
  hyprctl --batch "$BATCH_CMDS" >/dev/null 2>&1
  BATCH_CMDS=""
}

# ------------------------------------------------------------------
# Single-monitor workspace + keybind handling (batched)
# ------------------------------------------------------------------
handle_keybinds_single_mon() {
  echo "[LOG - SINGLE MON HELPER]: Reconfiguring to single monitor."

  # Ensure a valid focused workspace before any mutation
  batch "dispatch workspace 1"

  # Move all workspaces to eDP-1
  for i in $(seq 1 10); do
    batch "dispatch moveworkspacetomonitor $i eDP-1"
  done

  # Remove dual-monitor keybinds (exec-based)
  for i in $(seq 1 5); do
    batch "keyword unbind SUPER,$i,exec,~/.config/hypr/startupscripts/2_workspace.sh $i"
    echo "[LOG - SINGLE MON KEYBIND HELPER]: UNSET 2_workspace.sh keybinding $i."
  done

  # Restore standard workspace keybinds
  for i in $(seq 1 9); do
    batch "keyword bind SUPER,$i,workspace,$i"
  done
  batch "keyword bind SUPER,0,workspace,10"

  echo "[LOG - SINGLE MON KEYBIND HELPER]: SET workspace keybindings to SUPER+X."

  # Final focus sanity
  batch "dispatch workspace 1"
}

# ------------------------------------------------------------------
# Entry point
# ------------------------------------------------------------------
single_monitor_setup() {
  BATCH_CMDS=""

  handle_keybinds_single_mon
  echo "[LOG - SINGLE MONITOR]: Set Keybinds for Single Monitor Setup."

  # Configure internal display
  batch "keyword monitor eDP-1,preferred,auto,1"

  # Apply everything atomically
  commit_batch

  echo "[LOG - SINGLE MONITOR]: Reset display resolution, placement, and refresh rate."
}
