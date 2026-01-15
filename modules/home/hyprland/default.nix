{
  lib,
  host,
  ...
}: let
  inherit
    (import ./../../../hosts/${host}/variables.nix)
    hostType
    ;
in {
  imports = [
    ./animations-def.nix
    ./binds.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./keyboards.nix
    ./layerrules.nix
    ./pyprland.nix
    ./scripts.nix
    ./windowrules.nix
    ./workspaces.nix
  ];

  home.file = lib.mkMerge [
    (
      if hostType == "Laptop"
      then {
        ".config/hypr/startupscripts" = {
          source = ./startupscripts;
          recursive = true;
          executable = true;
        };
      }
      else {
        ".config/hypr/startupscripts/2_workspace.sh" = {
          source = ./startupscripts/2_workspace.sh;
          executable = true;
        };
      }
    )
  ];
}
