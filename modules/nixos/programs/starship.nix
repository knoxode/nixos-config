{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
    };
    presets = [ "pastel-powerline" ];
  };
}
