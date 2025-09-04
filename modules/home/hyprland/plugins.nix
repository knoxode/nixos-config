{host, ...}: let
  inherit (import ../../../hosts/${host}/variables.nix) hostType;
in {
  wayland.windowManager.hyprland = {
    settings =
      if hostType == "Laptop"
      then {
        plugin = {
          virtual-desktops = {
            rememberlayout = "monitors";
          };
        };
      }
      else {};
  };
}
