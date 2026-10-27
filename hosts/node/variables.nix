{
  # System Features
  hasRazer = true;
  hostType = "Desktop";
  forGaming = true;

  # Hyprland host data
  hyprland = {
    latitude = 51.75;
    longitude = -1.25;
    keyboards = {
      us = [
        "razer-razer-huntsman-mini"
        "razer-razer-huntsman-mini-keyboard"
      ];
      gb = [];
    };
  };

  # GPUs
  gpuDevices = {
    "nvidia-dgpu" = {
      vendor = "0x10de";
    };
  };

  # Enable Printing Support
  printEnable = true;

  # Auto-apply CI-validated flake.lock updates from origin/main
  autoUpdate = true;
}
