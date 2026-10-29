{
  pkgs,
  lib,
  ...
}: {
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
  # The steam module turns the 32-bit graphics stack on for Proton win32
  # titles, and its FHS env always adds `package32 ++ extraPackages32` to
  # the 32-bit library set — the NVIDIA module puts its 32-bit ICD into
  # extraPackages32 unconditionally. Empty both so the 32-bit NVIDIA driver
  # and 32-bit mesa stay out of the closure. 64-bit games and win64 Proton
  # builds are unaffected.
  hardware.graphics = {
    enable32Bit = lib.mkForce false;
    package32 = pkgs.runCommand "graphics-drivers-32-empty" { } "mkdir -p $out";
    extraPackages32 = lib.mkForce [ ];
  };
  hardware.steam-hardware.enable = true;
}
