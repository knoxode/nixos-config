{
  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "Alex Ryder";
  gitEmail = "powerskater3@gmail.com";

  # System Features
  hasRazer = true;
  hostType = "Laptop";
  forGaming = true;

  # Program Options
  browser = "firefox-nightly"; # Set Default Browser (google-chrome-stable for google-chrome)
  terminal = "kitty"; # Set Default System Terminal
  fileManager = "nautilus"; # Set Default File Manager (nemo, thunar, dolphin, pcmanfm)

  keyboardLayout = "us";
  consoleKeyMap = "us";
  keyboardLayouts = [
    {
      name = "razer-razer-blade";
      kb_layout = "gb";
    }
    {
      name = "razer-razer-blade-keyboard";
      kb_layout = "gb";
    }
    {
      name = "royuan-gaming-kb";
      kb_layout = "us";
    }
  ];

  intelID = "PCI:0:2:0";
  nvidiaID = "PCI:1:0:0";

  #Maps the cards to common names, and creates a consistent symlink
  gpuDevices = {
    "nvidia-dgpu" = {vendor = "0x10de";};
    "intel-igpu" = {vendor = "0x8086";};
  };

  # Enable NFS
  enableNFS = true;

  # Enable Printing Support
  printEnable = true;

  extraMonitorSettings = "
  ";
}
