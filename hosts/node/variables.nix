let
  centerMonitor = "Acer Technologies XB273U GX 3052185574200";
  leftMonitor = "Dell Inc. Dell S2716DG";
in {
  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "Alex Ryder";
  gitEmail = "powerskater3@gmail.com";

  # System Features
  hasRazer = true;
  hasNvidia = true;
  hostType = "Desktop";
  forGaming = true;
  centerMonitor = centerMonitor;
  leftMonitor = leftMonitor;

  keyboardLayout = "us";
  consoleKeyMap = "us";
  keyboardLayouts = [
    {
      name = "razer-razer-huntsman-mini";
      kb_layout = "us";
    }
    {
      name = "razer-razer-huntsman-mini-keyboard";
      kb_layout = "us";
    }
  ];

  # Program Options
  browser = "firefox-nightly"; # Set Default Browser (google-chrome-stable for google-chrome)
  terminal = "kitty"; # Set Default System Terminal
  fileManager = "nautilus"; # Set Default File Manager (nemo, thunar, dolphin, pcmanfm)

  # GPUs
  gpuDevices = {
    "nvidia-dgpu" = {
      vendor = "0x10de";
    };
  };

  # Enable NFS
  enableNFS = true;

  # Enable Printing Support
  printEnable = true;

  extraMonitorSettings = "
    monitorv2 {
      output=desc:${centerMonitor}
      mode = highrr
      position = auto
      scale = 1
      bitdepth = 10
      supports_hdr = 1
      sdrbrightness = 250
      max_luminance = 400
    }
    monitor=desc:${leftMonitor},highrr,auto-left,1
  ";
}
