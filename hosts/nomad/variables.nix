{
  # System Features
  hasRazer = true;
  hostType = "Laptop";
  forGaming = true;

  intelID = "PCI:0:2:0";
  nvidiaID = "PCI:1:0:0";

  #Maps the cards to common names, and creates a consistent symlink
  gpuDevices = {
    # "nvidia-dgpu" = {vendor = "0x10de";};
    "intel-igpu" = {vendor = "0x8086";};
  };

  # Enable Printing Support
  printEnable = true;
}
