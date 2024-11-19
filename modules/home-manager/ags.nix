{ config, pkgs, ... }:

{
  home.file.".config/ags/config.js".source = ./dotfiles/ags/config.js;
}
