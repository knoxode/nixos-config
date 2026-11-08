{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.alexos.host.gaming {
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        protontricks.enable = true;
        extest.enable = true;
        package = pkgs.steam.override {
          extraEnv = {
            OBS_VKCAPTURE = "1";
            RADV_TEX_ANISO = "16";
          };
        };
        extraCompatPackages = [
          pkgs.proton-ge-bin
        ];
      };
    };
    hardware.steam-hardware.enable = true;
  };
}
