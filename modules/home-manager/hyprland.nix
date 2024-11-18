{ config, pkgs, ... }:

{
  home.file.".config/hypr/hyprland.conf".source = ./../../dotfiles/hypr/hyprland.conf;
}
