{
  # System Features
  hasRazer = false;
  hostType = "Laptop";
  forGaming = false;

  #Maps the cards to common names, and creates a consistent symlink
  gpuDevices = {
    "intel-igpu" = {vendor = "0x8086";};
  };

  # Hyprland host data
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

  # Enable Printing Support
  printEnable = true;
}
