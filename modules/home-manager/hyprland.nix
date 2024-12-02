{ lib, ... }:

{
  home.file.".config/hypr/hyprland.conf" = lib.mkDefault {
    source = ./../../dotfiles/hypr/hyprland.conf;
  };
  home.file.".config/hypr/execs.conf" = lib.mkDefault {
    source = ./../../dotfiles/hypr/execs.conf;
  };
  home.file.".config/hypr/general.conf" = lib.mkDefault {
    source = ./../../dotfiles/hypr/general.conf;
  };
  home.file.".config/hypr/env.conf" = lib.mkDefault {
    source = ./../../dotfiles/hypr/env.conf;
  };
  home.file.".config/hypr/keybinds.conf" = lib.mkDefault {
    source = ./../../dotfiles/hypr/keybinds.conf;
  };
  home.file.".config/hypr/rules.conf" = lib.mkDefault {
    source = ./../../dotfiles/hypr/rules.conf;
  };
  home.file.".config/hypr/colors.conf" = lib.mkDefault {
    source = ./../../dotfiles/hypr/colors.conf;
  };
}

