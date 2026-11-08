{...}: {
  imports = [
    ./hardware.nix
  ];

  alexos.host = {
    gpu = "nvidia-prime";
    gaming = true;
    razer = true;
    hotplugMonitor = true;

    gpuBusIds = {
      intel = "PCI:0:2:0";
      nvidia = "PCI:1:0:0";
    };

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
          "razer-razer-blade"
          "razer-razer-blade-1"
          "razer-razer-blade-3"
        ];
      };
    };
  };
}
