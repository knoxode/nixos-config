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
  #   3. the commit has a green CI run on GitHub - hosts only ever switch to
  #      state that CI has evaluated and built.
  updateScript = pkgs.writeShellApplication {
    name = "alexos-auto-update";

    runtimeInputs = with pkgs; [
      curl
      git
      jq
      nh
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
      if ! state="$(curl -fsSL "https://api.github.com/repos/knoxode/nixos-config/commits/$head_sha/status" | jq -r .state)"; then
        echo "auto-update: could not query CI status for $head_sha, skipping"
        exit 0
      fi
      if [ "$state" != "success" ]; then
        echo "auto-update: CI status for $head_sha is '$state', skipping"
        exit 0
      fi

      echo "auto-update: applying CI-validated update $head_sha"
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
