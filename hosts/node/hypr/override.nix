{ lib, ... }:

{
  home-manager.users.shaiikura = {
    home.file = lib.mkOverride 10 {
      ".config/hypr/hyprland.conf".source = ./hyprland.conf;
      ".config/hypr/execs.conf".source = ./execs.conf;
      ".config/hypr/general.conf".source = ./general.conf;
      ".config/hypr/env.conf".source = ./env.conf;
      ".config/hypr/keybinds.conf".source = ./keybinds.conf;
      ".config/hypr/rules.conf".source = ./rules.conf;
      ".config/hypr/colors.conf".source = ./colors.conf;
    };
  };
}

