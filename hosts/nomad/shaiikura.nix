{ inputs, config, pkgs, ... }:

{
  home.username = "shaiikura";
  home.homeDirectory = "/home/shaiikura";
  imports = [
    inputs.nvchad4nix.homeManagerModule
    ../../modules/home-manager/sh.nix
    ../../modules/home-manager/firefox.nix
    ../../modules/home-manager/hyprland.nix
  ];

  home.file.".config/hypr/hyprland.conf".source = ./../../dotfiles/hypr/hyprland.conf;

  home.file.".config/rstudio/rstudio-prefs.json".source = ../../preferences/rstudio-prefs.json;

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
  ];

  programs.nvchad = {
    enable = true;
    backup = false;
  };

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

}
