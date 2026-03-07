{
  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "Alex Ryder";
  gitEmail = "powerskater3@gmail.com";

  # System Features
  hasRazer = false;
  hostType = "Laptop";
  forGaming = false;

  # Program Options
  browser = "firefox-nightly"; # Set Default Browser (google-chrome-stable for google-chrome)
  terminal = "ghostty"; # Set Default System Terminal
  fileManager = "nautilus"; # Set Default File Manager (nemo, thunar, dolphin, pcmanfm)

  #Maps the cards to common names, and creates a consistent symlink
  gpuDevices = {
    "intel-igpu" = {vendor = "0x8086";};
  };

  # Enable NFS
  enableNFS = true;

  # Enable Printing Support
  printEnable = true;

  keyboardLayout = "us";
  consoleKeyMap = "us";
  keyboardLayouts = [
    {
      name = "at-translated-set-2-keyboard";
      kb_layout = "gb";
    }
    {
      name = "royuan-gaming-kb";
      kb_layout = "us";
    }
    {
      name = "dell-kb216-wired-keyboard";
      kb_layout = "gb";
    }
    {
      name = "dell-kb216-wired-keyboard-consumer-control";
      kb_layout = "gb";
    }
    {
      name = "dell-kb216-wired-keyboard-system-control";
      kb_layout = "gb";
    }
  ];

  extraMonitorSettings = "
  ";
}
