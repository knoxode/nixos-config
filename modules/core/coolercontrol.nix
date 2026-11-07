{lib, ...}: {
  programs.coolercontrol = {
    enable = true;
  };

  # The BIOS controls fans/pump until the graphical session is up. Keep the
  # daemon off the boot-critical path: graphical.target completes first, then
  # systemd starts coolercontrold (Wants does not make the target wait).
  systemd.services.coolercontrold = {
    wantedBy = lib.mkForce ["graphical.target"];
    after = lib.mkForce [
      "graphical.target"
      "network.target"
      "lm-sensors.service"
      "lm_sensors.service"
    ];
  };
}
