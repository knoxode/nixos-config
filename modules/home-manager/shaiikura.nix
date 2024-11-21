{ inputs, pkgs, ... }:

{
  home.username = "shaiikura";
  home.homeDirectory = "/home/shaiikura";
  imports = [
    inputs.nvchad4nix.homeManagerModule
    ./ags.nix
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
      nodePackages.bash-language-server
      nil
      nixpkgs-fmt
    ];
    chadrcConfig = builtins.readFile ./../../preferences/nvim/chadrc.lua;
    extraConfig = builtins.readFile ./../../preferences/nvim/extraConfig.lua;
  };

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
