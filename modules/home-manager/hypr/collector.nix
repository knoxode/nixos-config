{ ... }:

let
  colors = import ./colors.nix;
  env = import ./env.nix;
  execs = import ./execs.nix;
  general = import ./general.nix;
  hyprland = import ./hyprland.nix;
  keybinds = import ./keybinds.nix;
  rules = import ./rules.nix;

  # Merge all configs into one attribute set
  mergedSettings = keybinds // colors // execs // general // hyprland // env // rules;

in {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = mergedSettings;
  };
}

