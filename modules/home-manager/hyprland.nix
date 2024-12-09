{ lib, ... }:

{
  home.file.".config/hypr/scripts/" = lib.mkDefault {
    source = ./../../dotfiles/hypr/scripts;
    executable = true;
  };
  home.file.".config/hypr/hyprland.conf" = lib.mkDefault {
    source = ./../../dotfiles/hypr/hyprland.conf;
    executable = true;
  };
  home.file.".config/hypr/hyprlock.conf.template" = lib.mkDefault {
    source = ./../../dotfiles/hypr/hyprlock.conf.template;
    executable = true;
  };
  home.file.".config/hypr/execs.conf" = lib.mkDefault {
    source = ./../../dotfiles/hypr/execs.conf;
    executable = true;
  };
  home.file.".config/hypr/general.conf" = lib.mkDefault {
    source = ./../../dotfiles/hypr/general.conf;
    executable = true;
  };
  home.file.".config/hypr/env.conf" = lib.mkDefault {
    source = ./../../dotfiles/hypr/env.conf;
    executable = true;
  };
  home.file.".config/hypr/keybinds.conf" = lib.mkDefault {
    source = ./../../dotfiles/hypr/keybinds.conf;
    executable = true;
  };
  home.file.".config/hypr/rules.conf" = lib.mkDefault {
    source = ./../../dotfiles/hypr/rules.conf;
    executable = true;
  };
  home.file.".config/hypr/colors.conf" = lib.mkDefault {
    source = ./../../dotfiles/hypr/colors.conf;
    executable = true;
  };
}

