{ inputs, pkgs, ... }:

{
  imports = [
    ./bash.nix
    ./firefox.nix
    ./hyprland.nix
    ./fastfetch.nix
    ./kitty.nix
    ./waypaper.nix
    ./grim.nix
    ./wlogout.nix
    ./spicetify.nix
    ./fish.nix
    ./rofi.nix
    ./onedrive.nix
    ./helix.nix
    ./rstudio-prefs.nix
    ./nvchad.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  home.packages = with pkgs; [
   htop 
   file    
   wl-clipboard
   # rstudio
   kitty
   mendeley
  ];
}
