{ inputs, config, pkgs, ... }:

{
  home.username = "shaiikura";
  home.homeDirectory = "/home/shaiikura";
  imports = [
    inputs.nvchad4nix.homeManagerModule
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  home.packages = with pkgs; [
   htop 
   file    
   wl-clipboard
  ];

  programs.nvchad = {
    enable = true;
  };

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
