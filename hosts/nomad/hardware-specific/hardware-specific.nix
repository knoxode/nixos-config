{ pkgs, lib, ... }:

{
  hardware.openrazer.enable = true;
  services.hardware.openrgb.enable = true;
  
  programs.coolercontrol = {
    enable = true;
    nvidiaSupport = true;
  };
}

