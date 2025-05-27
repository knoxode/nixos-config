{host, ...}: let
  hostVars = import ../../../hosts/${host}/variables.nix;
  inherit
    (hostVars)
    keyboardLayouts
    ;
in {
  wayland.windowManager.hyprland.settings = {
    device = keyboardLayouts;
  };
}
