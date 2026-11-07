{
  lib,
  pkgs,
  host,
  username,
  ...
}: let
  inherit (import ../../hosts/${host}/variables.nix) autoUpdate;

  flakeDir = "/home/${username}/alexos";

  # Applies origin/main automatically, but only when all conditions hold:
  #   1. the checkout is on main,
  #   2. tracked local edits are moved to a WIP branch, then restored after
  #      activation (never discarded),
  #   3. the update is a fast-forward, and
  #   4. the latest push CI run for the commit succeeded, including evaluation
  #      of every host and the aggregate build gate.
  updateScript = pkgs.writeShellApplication {
    name = "alexos-auto-update";

    runtimeInputs = with pkgs; [
      coreutils
      curl
      git
      jq
      nh
      nix
      util-linux
    ];

    text = ''
      set -euo pipefail

      repo="${flakeDir}"
      cd "$repo"

      # Fetch over HTTPS: the repo is public, so a root service needs no SSH
      # agent. The insteadOf mapping is per-invocation and never touches the
      # user's git config; pushes keep using their SSH key.
      runuser -u ${username} -- git -c url."https://github.com/".insteadOf=git@github.com: fetch origin main

      if ! runuser -u ${username} -- git merge-base --is-ancestor HEAD origin/main; then
        echo "auto-update: origin/main is not a fast-forward of HEAD, skipping"
        exit 0
      fi

      branch="$(runuser -u ${username} -- git branch --show-current)"
      if [ "$branch" != "main" ]; then
        echo "auto-update: current branch is '$branch', not main; skipping"
        exit 0
      fi

      changed="$(runuser -u ${username} -- git diff --name-only HEAD origin/main)"
      if [ "$changed" = "" ]; then
        exit 0
      fi

      head_sha="$(runuser -u ${username} -- git rev-parse origin/main)"
      api="https://api.github.com/repos/knoxode/nixos-config"

      # Use temporary files to avoid holding large API responses in shell
      # variables. Remove them automatically when the script exits.
      tmpdir="$(mktemp -d)"
      trap 'rm -rf "$tmpdir"' EXIT

      # Find the latest push-triggered Check workflow run for this exact
      # commit on main. PR and scheduled runs must not authorize deployment.
      if ! curl -fsSL \
        "$api/actions/workflows/check.yml/runs?branch=main&event=push&per_page=100" \
        -o "$tmpdir/runs.json"; then
        echo "auto-update: could not query CI runs for $head_sha, skipping"
        exit 0
      fi

      if ! run_id="$(jq -er --arg sha "$head_sha" '
        [.workflow_runs[]
         | select(.head_sha == $sha and
                  .event == "push" and
                  .head_branch == "main")]
        | sort_by(.created_at, .id)
        | last
        | .id // empty
      ' "$tmpdir/runs.json")"; then
        echo "auto-update: no valid push CI run found for $head_sha, skipping"
        exit 0
      fi

      state="$(jq -r --argjson id "$run_id" '
        .workflow_runs[]
        | select(.id == $id)
        | if .status == "completed" then
            .conclusion
          else
            .status
          end
      ' "$tmpdir/runs.json")"

      if [ "$state" != "success" ]; then
        echo "auto-update: CI run $run_id is '$state', skipping"
        exit 0
      fi

      # Verify that every required job succeeded within the same workflow
      # run. The build gate accepts skipped builds on push events by design.
      if ! curl -fsSL \
        "$api/actions/runs/$run_id/jobs?per_page=100" \
        -o "$tmpdir/jobs.json"; then
        echo "auto-update: could not query CI jobs for run $run_id, skipping"
        exit 0
      fi

      if ! jq -e '
        .jobs as $jobs |
        ["Evaluate reuby", "Evaluate node", "Evaluate nomad", "Build gate"]
        as $required |
        all($required[]; . as $name |
          [$jobs[] |
            select(.name == $name and
                   .status == "completed" and
                   .conclusion == "success")]
          | length == 1
        )
      ' "$tmpdir/jobs.json" >/dev/null; then
        echo "auto-update: required CI jobs not successful for $head_sha, skipping"
        exit 0
      fi

      # Only move local edits once there is a validated update to apply, so a
      # no-op run never touches the worktree. Never touch an in-progress
      # merge/rebase/cherry-pick.
      wip_branch=""
      if [ -n "$(runuser -u ${username} -- git status --porcelain --untracked-files=no)" ]; then
        for marker in MERGE_HEAD CHERRY_PICK_HEAD REVERT_HEAD; do
          if [ -e "$repo/.git/$marker" ]; then
            echo "auto-update: git operation in progress ($marker), skipping"
            exit 0
          fi
        done
        if [ -d "$repo/.git/rebase-merge" ] || [ -d "$repo/.git/rebase-apply" ]; then
          echo "auto-update: rebase in progress, skipping"
          exit 0
        fi

        wip_branch="auto-update-wip-$(date -u +%Y%m%d-%H%M%S)"
        echo "auto-update: moving tracked local changes to $wip_branch"
        runuser -u ${username} -- git switch -c "$wip_branch"
        runuser -u ${username} -- git add -u
        if ! runuser -u ${username} -- git commit \
          -m "auto-update: preserve local changes before applying $(runuser -u ${username} -- git rev-parse --short origin/main)"; then
          echo "auto-update: could not commit local changes; leaving them on $wip_branch, skipping"
          exit 0
        fi
        if ! runuser -u ${username} -- git switch main; then
          echo "auto-update: could not switch back to main; local changes are preserved on $wip_branch, skipping"
          exit 0
        fi
        echo "auto-update: local changes preserved on $wip_branch"
      fi

      echo "auto-update: applying CI-validated update $head_sha (run $run_id)"
      runuser -u ${username} -- git merge --ff-only origin/main

      # nh must run as a regular user; it escalates privileges internally.
      # Supply the user's environment explicitly for unattended execution.
      # Do not exec: the local edits still need to be put back afterwards.
      set +e
      runuser -u ${username} -- \
        env HOME="/home/${username}" NH_FLAKE="$repo" \
        nh os switch --hostname ${host} --elevation-strategy /run/wrappers/bin/sudo
      update_status=$?
      set -e

      # Put the tracked edits back on main after the update. If they no longer
      # apply cleanly, leave them committed on the WIP branch instead.
      if [ -n "$wip_branch" ]; then
        if runuser -u ${username} -- git cherry-pick --no-commit "$wip_branch"; then
          runuser -u ${username} -- git reset >/dev/null
          runuser -u ${username} -- git branch -D "$wip_branch" >/dev/null || true
          echo "auto-update: restored local changes on main"
        else
          runuser -u ${username} -- git cherry-pick --abort >/dev/null 2>&1 || true
          runuser -u ${username} -- git reset --hard >/dev/null
          runuser -u ${username} -- git switch "$wip_branch" || true
          echo "auto-update: could not reapply local changes to main; they remain on $wip_branch"
        fi
      fi

      exit "$update_status"
    '';
  };
in {
  systemd.services.alexos-auto-update = lib.mkIf autoUpdate {
    description = "Apply CI-validated flake.lock updates";

    # Don't interrupt the updater during the NixOS activation it initiated.
    # The updated unit definition takes effect on the next invocation.
    restartIfChanged = false;
    stopIfChanged = false;

    after = ["network-online.target"];
    wants = ["network-online.target"];

    environment = {
      NH_FLAKE = flakeDir;
      HOME = "/root";
    };

    serviceConfig = {
      Type = "oneshot";
      ExecStart = lib.getExe updateScript;
      # Background update: cap CPU use and deprioritize; it may take as long
      # as it takes.
      CPUQuota = "50%";
      Nice = 15;
      IOSchedulingClass = "idle";
    };
  };

  # Once a day, at 02:00. With Persistent=true a missed run (sleep/shutdown)
  # fires at the first boot or wake afterwards, so machines effectively check
  # first thing in the morning, in the background - before the workday starts.
  # The CI pipeline (03:43 UTC lock update + builds) finishes by early morning,
  # so a morning wake deploys the freshest validated state.
  systemd.timers.alexos-auto-update = lib.mkIf autoUpdate {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "02:00";
      Persistent = true;
      RandomizedDelaySec = "10min";
    };
  };
}
