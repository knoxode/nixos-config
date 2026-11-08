{...}: {
  imports = [
    ./hardware.nix
  ];

  alexos.host = {
    hotplugMonitor = true;

    gpuDevices = {
      "intel-igpu" = {
        vendor = "0x8086";
      };
    };

    hyprland = {
      latitude = 51.75;
      longitude = -1.25;
      keyboards = {
        us = [];
        gb = [
          "at-translated-set-2-keyboard"
          "royuan-gaming-kb"
          "dell-kb216-wired-keyboard"
          "dell-kb216-wired-keyboard-consumer-control"
          "dell-kb216-wired-keyboard-system-control"
        ];
      };
    };
  };
}
