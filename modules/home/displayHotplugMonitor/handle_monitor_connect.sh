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
# Monitor-specific helpers
# ------------------------------------------------------------------
prefers_fourkay() {
  # Expected format: WIDTHxHEIGHT@REFRESH
  local mode height

  mode="${external_monitor_preferred_mode}"

  height="$(printf '%s\n' "$mode" | cut -d'x' -f2 | cut -d'@' -f1)"

  if [[ -z "$height" || ! "$height" =~ ^[0-9]+$ ]]; then
    echo "[LOG - PREFERS_4K]: Failed to parse height from mode: $mode"
    return 1
  fi

  echo "[LOG - PREFERS_4K]: Detected Resolution is ${height}p."
  ((height > 1440))
}

monitor_specific_actions() {
  echo "[LOG - GENERAL]: ${external_monitor_model} was detected. Configuring dual monitor.."
  echo "[LOG - GENERAL]: Configuring dual monitor setup...."

  # Always ensure a valid focused workspace before mutating monitors
  batch "dispatch workspace 1"

  # Configure external monitor
  if [[ "${external_monitor_model}" == "Monitor TV" ]]; then
    batch "keyword monitor ${external_monitor_adapter},highres,auto-up,1"

  elif [[ "${external_monitor_model}" == "DELL P3425WE" ]]; then
    batch "keyword monitor ${external_monitor_adapter},highrr,auto,1"

  else
    if prefers_fourkay; then
      batch "keyword monitor ${external_monitor_adapter},preferred,auto,1.5"
    else
      batch "keyword monitor ${external_monitor_adapter},preferred,auto,1"
    fi
  fi

  # Configure internal display
  batch "keyword monitor eDP-1,preferred,auto-left,1"
}

# ------------------------------------------------------------------
# Workspace + keybind handling (batch-safe)
# ------------------------------------------------------------------
apply_dual_monitor_keybinds() {
  # Remove all existing SUPER+number binds (single or dual)
  for i in $(seq 0 9); do
    batch "keyword unbind SUPER,$i"
  done

  # Restore exec-based dual-monitor binds
  for i in $(seq 1 5); do
    batch "keyword bind SUPER,$i,exec,~/.config/hypr/startupscripts/2_workspace.sh $i"
  done
}

generic_dual_mon_helper() {
  # Move workspaces 1–5 to external monitor
  for i in $(seq 1 5); do
    batch "dispatch moveworkspacetomonitor $i ${external_monitor_adapter}"
  done

  # Move workspaces 6–10 to internal display
  for i in $(seq 6 10); do
    batch "dispatch moveworkspacetomonitor $i eDP-1"
  done

  # Ensure focus ends somewhere sane
  batch "dispatch workspace 1"
}

# ------------------------------------------------------------------
# Entry point
# ------------------------------------------------------------------
dual_monitor_topology_setup() {
  BATCH_CMDS=""
  monitor_specific_actions
  echo "[LOG - DUAL MONITOR]: Detected and queued monitor-specific actions."
  generic_dual_mon_helper
  echo "[LOG - DUAL MONITOR]: Reset monitor-wise ownership of workspaces."
  commit_batch
}

dual_monitor_keybind_setup() {
  BATCH_CMDS=""
  apply_dual_monitor_keybinds
  echo "[LOG - DUAL MONITOR]: Set Keybinds for Dual Monitor setup (2_workspace.sh)."
  commit_batch
}

dual_monitor_setup() {
  dual_monitor_topology_setup
  sleep 0.05
  dual_monitor_keybind_setup
}
