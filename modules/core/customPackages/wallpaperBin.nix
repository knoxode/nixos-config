{
  pkgs,
  lib,
  ...
}: let
  dynamicWallpaper = pkgs.writeShellApplication {
    name = "dynamicWallpaper";

    runtimeInputs = with pkgs; [
      bash
      waypaper
      swww
      coreutils
      findutils
      util-linux
    ];

    # disable checks if shellcheck complains:
    # doCheck = false;

    text = ''
      #!${pkgs.runtimeShell}
      set -euo pipefail

      WALLPAPER_DIR="$HOME/Pictures/DesktopBackground"
      INTERVAL=5
      DYNAMIC_WALLPAPER_FILE="$HOME/.cache/.wallpaper"

      mkdir -p "$HOME/.cache"

      RANDOM_WAYPAPER_OUTPUT=$(waypaper --random 2>&1)
      INIT_IMAGE=$(printf '%s\n' "$RANDOM_WAYPAPER_OUTPUT" | awk ' NR==1 {sub(/^Selected file: /,"");print; exit }')

      cp -- "$INIT_IMAGE" "$DYNAMIC_WALLPAPER_FILE"

      sleep "$INTERVAL"

      while true; do
        first=true
        for IMAGE in $(find -L "$WALLPAPER_DIR" -type f | shuf); do
          if $first && [ "$IMAGE" = "$INIT_IMAGE" ]; then
            first=false
            continue
          fi
          first=false

          cp -- "$IMAGE" "$DYNAMIC_WALLPAPER_FILE"
          waypaper --fill fill --wallpaper "$IMAGE" --backend swww
          sleep "$INTERVAL"
        done
      done
    '';
  };
in {
  # install into system profile
  environment.systemPackages = lib.mkDefault [
    dynamicWallpaper
  ];
}
