{
  pkgs,
  username,
  ...
}: let
  # nh wrapper: gates switch/boot/test on a pure evaluation of the target
  # host's toplevel before touching the system. Evaluation errors and failed
  # assertions abort; warnings are shown but do not block. For `--update`,
  # the flake lock is refreshed first so the gate evaluates the post-update
  # state, not the previous one.
  nhv = pkgs.writeShellApplication {
    name = "nhv";

    runtimeInputs = with pkgs; [
      nh
      nix
      hostname
    ];

    text = ''
      set -euo pipefail

      flake="''${NH_FLAKE:-}"
      if [[ -z "$flake" ]]; then
        echo "nhv: NH_FLAKE is not set; cannot locate the flake to evaluate" >&2
        exit 1
      fi

      subcmd=""
      if [[ $# -gt 0 ]]; then
        subcmd="$1"
        shift
      fi
      # tolerate both "nhv switch ..." and "nhv os switch ..."
      if [[ "$subcmd" == "os" && $# -gt 0 ]]; then
        subcmd="$1"
        shift
      fi

      case "$subcmd" in
        switch | boot | test)
          host="$(hostname -s)"
          args=()
          update=0
          while [[ $# -gt 0 ]]; do
            case "$1" in
              --update)
                update=1
                shift
                ;;
              --hostname | -H)
                if [[ $# -lt 2 ]]; then
                  echo "nhv: $1 requires an argument" >&2
                  exit 1
                fi
                host="$2"
                args+=("$1" "$2")
                shift 2
                ;;
              --hostname=* | -H=*)
                host="''${1#*=}"
                args+=("$1")
                shift
                ;;
              *)
                args+=("$1")
                shift
                ;;
            esac
          done

          if [[ "$update" -eq 1 ]]; then
            echo "nhv: updating flake.lock in $flake"
            nix flake update "$flake"
          fi

          echo "nhv: evaluating ''${flake}#nixosConfigurations.''${host} before nh ''${subcmd}"
          if ! nix eval "''${flake}#nixosConfigurations.''${host}.config.system.build.toplevel.drvPath" >/dev/null; then
            echo "nhv: evaluation failed - aborting before nh ''${subcmd}" >&2
            exit 1
          fi

          exec nh os "$subcmd" "''${args[@]}"
          ;;
        "")
          exec nh
          ;;
        *)
          exec nh "$subcmd" "$@"
          ;;
      esac
    '';
  };
in {
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 4d --keep 3";
    };
    flake = "/home/${username}/alexos";
  };

  environment.systemPackages = with pkgs; [
    nix-output-monitor
    nvd
    nhv
  ];
}
