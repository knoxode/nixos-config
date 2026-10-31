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
  #   1. the working tree is clean (tracked files) - never clobber local work,
  #   2. the update is a fast-forward, and
  #   3. the latest push CI run for the commit succeeded, including evaluation
  #      of every host and the aggregate build gate.
  #
  # Full builds of flake.lock updates are enforced separately by the PR
  # workflow and branch protection; push runs on main are evaluation-only.
  updateScript = pkgs.writeShellApplication {
    name = "alexos-auto-update";

    runtimeInputs = with pkgs; [
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

      if [ -n "$(runuser -u ${username} -- git status --porcelain --untracked-files=no)" ]; then
        echo "auto-update: tracked local changes present, skipping"
        exit 0
      fi

      # Fetch over HTTPS: the repo is public, so a root service needs no SSH
      # agent. The insteadOf mapping is per-invocation and never touches the
      # user's git config; pushes keep using their SSH key.
      runuser -u ${username} -- git -c url."https://github.com/".insteadOf=git@github.com: fetch origin main

      if ! runuser -u ${username} -- git merge-base --is-ancestor HEAD origin/main; then
        echo "auto-update: origin/main is not a fast-forward of HEAD, skipping"
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

      echo "auto-update: applying CI-validated update $head_sha (run $run_id)"
      runuser -u ${username} -- git merge --ff-only origin/main
      exec nh os switch --hostname ${host}
    '';
  };
in {
  systemd.services.alexos-auto-update = lib.mkIf autoUpdate {
    description = "Apply CI-validated flake.lock updates";
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
