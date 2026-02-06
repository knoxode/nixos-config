#!/usr/bin/env bash
set +e
external_monitor_adapter=""
external_monitor_model=""
external_monitor_preferred_mode=""

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------

current_monitor_count() {
  hyprctl monitors -j | jq length
}

snapshot_workspaces() {
  # Only real workspaces (exclude scratchpads / special)
  hyprctl workspaces -j |
    jq -r '.[] | select(.id > 0) | "\(.id) \(.monitor)"'
}

# -----------------------------------------------------------------------------
# Main reconcile function
# -----------------------------------------------------------------------------

reconcile_monitors() {
  local prev_count curr_count
  local last_ws
  local monitor_count
  local post_ws_json

  # ---------------------------------------------------------------------------
  # Phase 0 — restart decision (monitor COUNT only)
  # ---------------------------------------------------------------------------

  prev_count="${LAST_MONITOR_COUNT:-}"
  curr_count="$(current_monitor_count)"

  LAST_MONITOR_COUNT="$curr_count"
  export LAST_MONITOR_COUNT

  RESTART_NOCTALIA=0
  FRIENDLY_NOC_OUT="Not Restarting."
  if [[ -n "$prev_count" && "$prev_count" != "$curr_count" ]]; then
    FRIENDLY_NOC_OUT="Restarting."
    RESTART_NOCTALIA=1
  fi
  export RESTART_NOCTALIA

  if [[ -z "$prev_count" ]]; then
    monitors_changed="Baseline"
  elif [[ "$prev_count" != "$curr_count" ]]; then
    monitors_changed="Yes"
  else
    monitors_changed="No"
  fi

  echo "[LOG - RECONCILE MONITORS] RESTART_CHECK : Monitor State = $monitors_changed (prev=${prev_count:-Not known}, curr=$curr_count)"
  echo "[LOG - RECONCILE MONITORS] RESTART_CHECK : Noctalia restart decision = $FRIENDLY_NOC_OUT"

  # ---------------------------------------------------------------------------
  # Phase 1 — snapshot intent
  # ---------------------------------------------------------------------------

  if [[ "${USE_CACHED_WORKSPACE:-0}" -eq 1 &&
    -n "${LAST_WORKSPACE:-}" ]]; then
    last_ws="$LAST_WORKSPACE"
    echo "[LOG - RECONCILE MONITORS] PRE-CONFIG-SET : USING CACHED WORKSPACE=$last_ws"

    USE_CACHED_WORKSPACE=0
    LAST_WORKSPACE=""
    export USE_CACHED_WORKSPACE
    export LAST_WORKSPACE
  else
    read -r last_ws < <(
      hyprctl activeworkspace -j |
        jq -r '.id // 1'
    )
    echo "[LOG - RECONCILE MONITORS] PRE-CONFIG-SET : USING LIVE WORKSPACE=$last_ws"
  fi

  if ((last_ws <= 0)); then
    last_ws=1
  fi

  # ---------------------------------------------------------------------------
  # Phase 2 — apply topology
  # ---------------------------------------------------------------------------

  monitor_count="$curr_count"

  if ((monitor_count > 1)); then
    external_monitor_adapter=$(
      hyprctl monitors -j |
        jq -r '.[] | select(.name != "eDP-1") | .name'
    )

    external_monitor_model=$(
      hyprctl monitors -j |
        jq -r '.[] | select(.name != "eDP-1") | .model'
    )

    external_monitor_preferred_mode=$(
      hyprctl monitors -j |
        jq -r '.[] | select(.name != "eDP-1") | .availableModes[0]'
    )

    export external_monitor_adapter
    export external_monitor_model
    export external_monitor_preferred_mode

    echo "[LOG - RECONCILE MONITORS] TOPOLOGY : DUAL MONITOR - ADAPTER = $external_monitor_adapter"
    dual_monitor_setup
  else
    echo "[LOG - RECONCILE MONITORS] TOPOLOGY : SINGLE MONITOR"
    single_monitor_setup
  fi

  # ---------------------------------------------------------------------------
  # Phase 3 — restore focus (dual-monitor aware, no remediation)
  # ---------------------------------------------------------------------------

  post_ws_json="$(hyprctl workspaces -j)"
  workspace_exists() {
    jq -e ".[] | select(.id == $1)" <<<"$post_ws_json" >/dev/null
  }

  if ((monitor_count == 1)); then
    # Single monitor
    if workspace_exists "$last_ws"; then
      hyprctl dispatch workspace "$last_ws" >/dev/null 2>&1
      echo "[LOG - RECONCILE MONITORS] FOCUS : RESTORED SINGLE WORKSPACE=$last_ws"
    else
      hyprctl dispatch workspace 1 >/dev/null 2>&1
      echo "[LOG - RECONCILE MONITORS] FOCUS : FALLBACK SINGLE WORKSPACE=1"
    fi

  else
    # Dual monitor
    if ((last_ws >= 1 && last_ws <= 5)); then
      paired_ws=$((last_ws + 5))

      workspace_exists "$last_ws" &&
        hyprctl dispatch workspace "$last_ws" >/dev/null 2>&1

      workspace_exists "$paired_ws" &&
        hyprctl dispatch workspace "$paired_ws" >/dev/null 2>&1

      echo "[LOG - RECONCILE MONITORS] FOCUS : RESTORED DUAL PAIR=($last_ws,$paired_ws)"

    elif ((last_ws >= 6 && last_ws <= 10)); then
      paired_ws=$((last_ws - 5))

      workspace_exists "$paired_ws" &&
        hyprctl dispatch workspace "$paired_ws" >/dev/null 2>&1

      workspace_exists "$last_ws" &&
        hyprctl dispatch workspace "$last_ws" >/dev/null 2>&1

      echo "[LOG - RECONCILE MONITORS] FOCUS : RESTORED DUAL PAIR=($paired_ws,$last_ws)"

    else
      hyprctl dispatch workspace 1 >/dev/null 2>&1
      echo "[LOG - RECONCILE MONITORS] FOCUS : FALLBACK DUAL WORKSPACE=1 INVALID_LAST_WS=$last_ws"
    fi
  fi

  # ---------------------------------------------------------------------------
  # Phase 4 — persist focus intent
  # ---------------------------------------------------------------------------

  LAST_WORKSPACE="$last_ws"
  export LAST_WORKSPACE

  echo "[LOG - RECONCILE MONITORS] POST-CONFIG-SET : Persisting Workspace = $LAST_WORKSPACE"

  return 0
}
