#!/usr/bin/env bash
set +e
LAST_TOPOLOGY=""

current_monitor_topology() {
  hyprctl monitors -j |
    jq -r '.[] | "\(.name)|\(.model)"' |
    sort |
    tr '\n' ';'
}

snapshot_workspaces() {
  hyprctl workspaces -j |
    jq -r '.[] | select(.id > 0) | "\(.id) \(.monitor)"'
}

wait_for_transient_workspaces() {
  local tries=20
  local delay=0.05

  while ((tries-- > 0)); do
    if hyprctl workspaces -j |
      jq -e '.[].id | select(. > 10)' >/dev/null; then
      return 0
    fi
    sleep "$delay"
  done

  return 1
}

reconcile_monitors() {
  local topology topology_changed=0
  local last_ws
  local pre_ws post_ws
  local monitor_count

  # ------------------------------------------------------------------
  # Phase 0 — snapshot monitor topology (restart decision)
  # ------------------------------------------------------------------
  topology=$(current_monitor_topology)

  if [[ "$topology" != "$LAST_TOPOLOGY" ]]; then
    topology_changed=1
    LAST_TOPOLOGY="$topology"
  fi

  # ------------------------------------------------------------------
  # Phase 1 — snapshot workspace state + intent
  # ------------------------------------------------------------------

  # Workspace → monitor mapping before changes
  pre_ws="$(snapshot_workspaces)"

  # Last focused workspace (single integer)
  read -r last_ws < <(
    hyprctl clients -j |
      jq -r '
        sort_by(.focusHistoryID)
        | reverse
        | map(select(.workspace.id > 0))
        | .[0].workspace.id // 1
      '
  )

  if ((last_ws <= 0)); then
    echo "[WARN]: Ignoring invalid last_ws=$last_ws; defaulting to workspace 1"
    last_ws=1
  fi

  echo "[LOG - LAST WS. CHECK. ]: Detected last workspace = $last_ws."

  # ------------------------------------------------------------------
  # Phase 2 — apply topology (batched elsewhere)
  # ------------------------------------------------------------------
  monitor_count=$(hyprctl monitors -j | jq length)

  if ((monitor_count > 1)); then
    external_monitor_adapter=$(
      hyprctl monitors -j |
        jq -r '.[] | select(.name != "eDP-1") | .name' | xargs
    )

    external_monitor_model=$(
      hyprctl monitors -j |
        jq -r '.[] | select(.name != "eDP-1") | .model' | xargs
    )

    external_monitor_preferred_mode=$(
      hyprctl monitors -j |
        jq -r '.[] | select(.name != "eDP-1") | .availableModes[0]' | xargs
    )

    export external_monitor_adapter
    export external_monitor_model
    export external_monitor_preferred_mode

    echo "[LOG - DUAL MONITOR]: Dual Monitor Adapter Detected. $external_monitor_adapter."
    echo "[LOG - DUAL MONITOR]: Dual Monitor Model Detected. $external_monitor_model."
    echo "[LOG - DUAL MONITOR]: Dual Monitor Preferred Mode Detected: $external_monitor_preferred_mode."

    echo "[LOG - DUAL MONITOR]: Dual Monitor Detected. Beginning Configuration."
    dual_monitor_setup
  else
    echo "[LOG - SINGLE MONITOR]: Single Monitor Detected. Beginning Configuration."
    single_monitor_setup
  fi

  # ------------------------------------------------------------------
  # Phase 3 — re-snapshot workspaces after mutation
  # ------------------------------------------------------------------
  if ! wait_for_transient_workspaces; then
    echo "[WARN]: No transient workspaces detected; skipping remediation"
  fi

  # post_ws_raw is a newline list "id monitor"
  post_ws_raw="$(snapshot_workspaces)"

  # Build quick lookup lists (IDs only)
  pre_ids=$(printf '%s\n' "$pre_ws" | awk '$1 > 0 {print $1}' | sort -n | tr '\n' ' ')
  post_ids=$(printf '%s\n' "$post_ws_raw" | awk '$1 > 0 {print $1}' | sort -n | tr '\n' ' ')
  echo "[LOG]: Detected WS' before applied changes: $pre_ids"
  echo "[LOG]: Detected WS' before applied changes: $post_ids"

  # Compute new ids: present in post but not in pre
  new_ids=()
  for id in $post_ids; do
    if ! grep -qw -- "$id" <<<"$pre_ids"; then
      new_ids+=("$id")
    fi
  done

  if ((${#new_ids[@]} > 0)); then
    echo "[INFO]: Detected new/transient workspace IDs: ${new_ids[*]} — attempting remediation"

    remap_canonical_workspaces() {
      # Put canonical mapping back:
      # - 1..5 -> external monitor (your earlier scheme)
      # - 6..10 -> eDP-1
      # Adjust if your intended pairing differs.
      for i in $(seq 1 5); do
        hyprctl dispatch moveworkspacetomonitor "$i" "$external_monitor_adapter" >/dev/null 2>&1 || true
      done
      for i in $(seq 6 10); do
        hyprctl dispatch moveworkspacetomonitor "$i" "eDP-1" >/dev/null 2>&1 || true
      done

      # Ensure keybinds are consistent (optional: call your helper that sets binds)
      # generic_dual_mon_helper  # <-- if you want the helper to reapply binds

      echo "[INFO]: Canonical workspaces 1-10 remapped to expected monitors."
    }

    remap_canonical_workspaces

    # Re-snapshot after remediation (best-effort)
    post_ws_raw="$(snapshot_workspaces)"
    echo "[INFO]: Workspace layout following remediation: $post_ws_raw"
  fi

  # Create post_ws JSON object to use with workspace_exists()
  post_ws="$(hyprctl workspaces -j)"
  workspace_exists() {
    jq -e ".[] | select(.id == $1)" <<<"$post_ws" >/dev/null
  }

  # ------------------------------------------------------------------
  # Phase 4 — restore focus & enforce paired workspace layout
  # ------------------------------------------------------------------

  monitor_count=$(hyprctl monitors -j | jq length)

  if ((monitor_count == 1)); then
    echo "[LOG - SINGLE MONITOR]: Attempting to restore focus to workspace $last_ws on eDP-1."

    if workspace_exists "$last_ws"; then
      hyprctl dispatch workspace "$last_ws"
      echo "[LOG - SINGLE MONITOR]: Focus restored to workspace $last_ws on eDP-1."
    else
      hyprctl dispatch workspace 1
      echo "[LOG - SINGLE MONITOR]: Workspace $last_ws missing; fell back to workspace 1 on eDP-1."
    fi

  else
    # Dual monitor: restore focus and ensure paired workspace exists

    if ((last_ws >= 1 && last_ws <= 5)); then
      paired_ws=$((last_ws + 5))

      echo "[LOG - DUAL MONITOR]: Restoring focus to workspace $last_ws on external monitor."
      hyprctl dispatch workspace "$last_ws"

      echo "[LOG - DUAL MONITOR]: Ensuring paired workspace $paired_ws exists on eDP-1."
      if workspace_exists "$paired_ws"; then
        echo "[LOG - DUAL MONITOR]: Paired workspace $paired_ws already present on eDP-1."
      else
        hyprctl dispatch moveworkspacetomonitor "$paired_ws" eDP-1
        echo "[LOG - DUAL MONITOR]: Paired workspace $paired_ws moved to eDP-1."
      fi

    elif ((last_ws >= 6 && last_ws <= 10)); then
      paired_ws=$((last_ws - 5))

      echo "[LOG - DUAL MONITOR]: Restoring focus to workspace $last_ws on eDP-1."
      hyprctl dispatch workspace "$last_ws"

      echo "[LOG - DUAL MONITOR]: Ensuring paired workspace $paired_ws exists on $external_monitor_adapter."
      if workspace_exists "$paired_ws"; then
        echo "[LOG - DUAL MONITOR]: Paired workspace $paired_ws already present on $external_monitor_adapter."
      else
        hyprctl dispatch moveworkspacetomonitor "$paired_ws" "$external_monitor_adapter"
        echo "[LOG - DUAL MONITOR]: Paired workspace $paired_ws moved to $external_monitor_adapter."
      fi

    else
      hyprctl dispatch workspace 1
      echo "[LOG - DUAL MONITOR]: FALLBACK: Invalid last_ws=$last_ws; focused workspace 1."
    fi
  fi

  # ------------------------------------------------------------------
  # Phase 5 — return topology change status
  # ------------------------------------------------------------------
  return "$topology_changed"
}
