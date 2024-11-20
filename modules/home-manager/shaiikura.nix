{ inputs, config, pkgs, ... }:

{
  home.username = "shaiikura";
  home.homeDirectory = "/home/shaiikura";
  imports = [
    inputs.nvchad4nix.homeManagerModule
    ./sh.nix
    ./firefox.nix
    ./hyprland.nix
  ];

  home.file.".config/hypr/hyprland.conf".source = ./../../dotfiles/hypr/hyprland.conf;

  home.file.".config/rstudio/rstudio-prefs.json".source = ./../../preferences/rstudio-prefs.json;

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
   spotify
   spicetify-cli
  ];

  programs.nvchad = {
    enable = true;
    backup = false;
    extraPackages = with pkgs; [
      nil
    ];
  };

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

}
