{
  host,
  lib,
  ...
}: let
  inherit (import ../../hosts/${host}/variables.nix) hostType;
  isDesktop = hostType == "Desktop";
  isLaptop = !isDesktop;
in {
  # Only force governor on desktop
  powerManagement.cpuFreqGovernor =
    lib.mkIf isDesktop "schedutil";
  services.power-profiles-daemon.enable = isLaptop;
}
