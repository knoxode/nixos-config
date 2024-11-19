{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
      git
      starship
      jetbrains-mono
      tree
      google-chrome
      ags
      brightnessctl
      fastfetch
      os-prober
  ];
}
