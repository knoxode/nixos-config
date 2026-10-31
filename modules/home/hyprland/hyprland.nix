{
  host,
  lib,
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
  ];
  # Place Files Inside Home Directory
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    systemd.enable = true;
    xwayland = {
      enable = true;
    };
    extraConfig = ''
      -- Hyprland configuration is managed externally.
    '';
  };
  xdg.configFile."hypr/hyprland.lua".enable = lib.mkForce false;
}
