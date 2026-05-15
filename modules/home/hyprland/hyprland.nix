{
  host,
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit
    (import ../../../hosts/${host}/variables.nix)
    hostType
    ;
in {
  home.packages = with pkgs; [
    awww
    grim
    slurp
    wl-clipboard
    hyprpolkitagent
    hyprland-qtutils # needed for banners and ANR messages
  ];
  # Place Files Inside Home Directory
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    xwayland = {
      enable = true;
    };
  };
}
