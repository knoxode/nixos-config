let
  centerMonitor = "Acer Technologies XB273U GX 3052185574200";
  leftMonitor   = "Dell Inc. Dell S2716DG";
in
{
  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "Alex Ryder";
  gitEmail = "powerskater3@gmail.com";

  # System Features
  hasRazer      = true;
  hostType      = "Desktop";
  forGaming     = true;
  centerMonitor = centerMonitor;
  leftMonitor   = leftMonitor;


  # Program Options
  browser = "firefox"; # Set Default Browser (google-chrome-stable for google-chrome)
  terminal = "kitty"; # Set Default System Terminal
  fileManager = "nautilus"; # Set Default File Manager (nemo, thunar, dolphin, pcmanfm) 
  keyboardLayout = "us";
  consoleKeyMap = "us";

  # For Nvidia Prime support
  intelID = "PCI:1:0:0";
  nvidiaID = "PCI:0:2:0";

  # Enable NFS
  enableNFS = true;

  # Enable Printing Support
  printEnable = true;

  extraMonitorSettings = "
    monitor=desc:${centerMonitor},highrr,auto,1
    monitor=desc:${leftMonitor},highrr,auto-left,1
  ";
}

