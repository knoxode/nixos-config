{
  lib,
  pkgs,
  config,
  host,
  ...
}:
with lib; let
  cfg = config.drivers.nvidia;
  inherit (import ./../../hosts/${host}/variables.nix) hasNvidia;
in {
  options.drivers.nvidia = {
    enable = mkEnableOption "Enable Nvidia Drivers";
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      modesetting.enable = true;

      powerManagement.enable = true;
      powerManagement.finegrained = false;

      open = true;
      nvidiaSettings = true;

      package =
        if hasNvidia == true
        then let
          fixPatch = pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/CachyOS/kernel-patches/master/6.19/misc/nvidia/0003-Fix-compile-for-6.19.patch";
            hash = "sha256-YuJjSUXE6jYSuZySYGnWSNG5sfVei7vvxDcHx3K+IN4=";
          };

          base = config.boot.kernelPackages.nvidiaPackages.beta;
        in
          base
          // {
            open = base.open.overrideAttrs (old: {
              patches = (old.patches or []) ++ [fixPatch];
            });
          }
        else config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
