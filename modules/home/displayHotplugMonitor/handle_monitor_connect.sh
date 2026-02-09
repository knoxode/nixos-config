#!/usr/bin/env bash
set +e

# ================================================================
# Globals / constants
# ================================================================
INTERNAL_MONITOR="eDP-1"
BATCH_CMDS=""

log() {
  echo "[LOG - DUAL MONITOR]: $*"
}

# ================================================================
# Batch helpers
# ================================================================
batch() {
  BATCH_CMDS+="$1;"
}

commit_batch() {
  [[ -z "$BATCH_CMDS" ]] && return 0
  hyprctl --batch "$BATCH_CMDS" >/dev/null 2>&1
  BATCH_CMDS=""
}

# ================================================================
# Monitor helpers
# ================================================================
prefers_fourkay() {
  local mode height
  mode="${external_monitor_preferred_mode}"

  height="$(printf '%s\n' "$mode" | cut -d'x' -f2 | cut -d'@' -f1)"

  [[ "$height" =~ ^[0-9]+$ ]] || return 1
  ((height > 1440))
}

configure_monitors() {
  log "Configuring monitor layout for model: ${external_monitor_model}"
  case "${external_monitor_model}" in
  "Monitor TV")
    batch "keyword monitor ${external_monitor_adapter},highres,auto-up,1"
    ;;
  "DELL P3425WE")
    batch "keyword monitor ${external_monitor_adapter},highrr,auto,1"
    ;;
  *)
    if prefers_fourkay; then
      batch "keyword monitor ${external_monitor_adapter},preferred,auto,1.5"
    else
      batch "keyword monitor ${external_monitor_adapter},preferred,auto,1"
    fi
    ;;
  esac

  batch "keyword monitor ${INTERNAL_MONITOR},preferred,auto-left,1"
}

# ================================================================
# Workspace handling
# ================================================================
move_workspaces_dual() {
  log "Assigning workspaces to monitors"
  # Move workspaces 1–5 to external monitor
  for i in $(seq 1 5); do
    batch "dispatch moveworkspacetomonitor $i ${external_monitor_adapter}"
  done

  # Move workspaces 6–10 to internal display
  for i in $(seq 6 10); do
    batch "dispatch moveworkspacetomonitor $i ${INTERNAL_MONITOR}"
  done
}

# ================================================================
# Keybind handling
# ================================================================
apply_dual_monitor_keybinds() {
  log "Applying dual-monitor keybinds"

  # Remove all numeric SUPER binds
  for i in {0..9}; do
    batch "keyword unbind SUPER,${i}"
  done

  # Restore exec-based dual bindings
  for i in {1..5}; do
    batch "keyword bind SUPER,${i},exec,bash $HOME/.config/hypr/startupscripts/2_workspace.sh ${i}"
  done

}

# ================================================================
# Topology setup (PHASED)
# ================================================================
dual_monitor_topology_setup() {
  log "Applying monitor configuration (may reseat external monitor)"

  BATCH_CMDS=""
  configure_monitors
  commit_batch

  log "Monitor configuration stabilized"
}

dual_monitor_keybind_setup() {
  BATCH_CMDS=""
  apply_dual_monitor_keybinds
  commit_batch
}

dual_monitor_workspace_setup() {
  BATCH_CMDS=""
  move_workspaces_dual
  commit_batch
}

# ================================================================
# Entry point
# ================================================================
dual_monitor_setup() {
  dual_monitor_topology_setup
  dual_monitor_keybind_setup
  dual_monitor_workspace_setup
}
