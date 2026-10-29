{
  # System Features
  hasRazer = true;
  hostType = "Laptop";
  forGaming = true;
  # Battery over latency: roaming laptop.
  wifiPowersave = true;

  intelID = "PCI:0:2:0";
  nvidiaID = "PCI:1:0:0";

  #Maps the cards to common names, and creates a consistent symlink
  gpuDevices = {
    # "nvidia-dgpu" = {vendor = "0x10de";};
    "intel-igpu" = {vendor = "0x8086";};
  };

  # Hyprland host data
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

  # Enable Printing Support
  printEnable = true;

  # Auto-apply CI-validated flake.lock updates from origin/main
  autoUpdate = true;
}
