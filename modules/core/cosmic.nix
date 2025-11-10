{lib, ...}: {
  services.desktopManager.cosmic.enable = true;
  services.power-profiles-daemon.enable = lib.mkForce false;
}
