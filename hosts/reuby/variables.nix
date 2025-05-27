{
  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "Alex Ryder";
  gitEmail = "powerskater3@gmail.com";

  # System Features
  hasRazer = false;
  hostType = "Laptop";
  forGaming = false;

  # Program Options
  browser = "firefox"; # Set Default Browser (google-chrome-stable for google-chrome)
  terminal = "kitty"; # Set Default System Terminal
  fileManager = "nautilus"; # Set Default File Manager (nemo, thunar, dolphin, pcmanfm)

  # For Nvidia Prime support
  intelID = "PCI:1:0:0";
  nvidiaID = "PCI:0:2:0";

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
  ];

  extraMonitorSettings = "
  ";
}
