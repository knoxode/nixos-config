{
  config,
  lib,
  ...
}: let
  isDesktop = config.alexos.host.formFactor == "desktop";
  isLaptop = !isDesktop;
in {
  # Only force governor on desktop
  powerManagement.cpuFreqGovernor =
    lib.mkIf isDesktop "schedutil";
  services.power-profiles-daemon.enable = isLaptop;
}
