{
  config,
  lib,
  pkgs,
  host,
  username,
  repoRoot,
  ...
}: let
  # Applies origin/main automatically, but only when all conditions hold:
  #   1. the checkout is on main,
  #   2. tracked local edits are moved to a WIP branch, then restored after
  #      activation (never discarded),
  #   3. the update is a fast-forward, and
  #   4. the latest push CI run for the commit succeeded, including the
  #      aggregate Evaluate gate and Build gate.
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
    runtimeEnv = {
      ALEXOS_REPO = repoRoot;
      ALEXOS_HOST = host;
      ALEXOS_USER = username;
    };

    text = builtins.readFile ./auto-update.sh;
  };
in {
  systemd.services.alexos-auto-update = lib.mkIf config.alexos.host.autoUpdate {
    description = "Apply CI-validated flake.lock updates";

    # Don't interrupt the updater during the NixOS activation it initiated.
    # The updated unit definition takes effect on the next invocation.
    restartIfChanged = false;
    stopIfChanged = false;

    after = ["network-online.target"];
    wants = ["network-online.target"];

    environment = {
      NH_FLAKE = repoRoot;
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
  systemd.timers.alexos-auto-update = lib.mkIf config.alexos.host.autoUpdate {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "02:00";
      Persistent = true;
      RandomizedDelaySec = "10min";
    };
  };
}
