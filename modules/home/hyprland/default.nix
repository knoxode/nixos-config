{
  config,
  lib,
  ...
}: let
  hyprDir = "/home/shaiikura/alexos/modules/home/hyprland";

  files = [
    "helpers"
    "systems"
    "events"
    "machine_specific"
    "animations.lua"
    "appearance.lua"
    "binds.lua"
    "devices.lua"
    "env.lua"
    "exec.lua"
    "gpu.lua"
    "hyprland.lua"
    "layouts.lua"
    "misc.lua"
    "monitors.lua"
    "node_specific.lua"
    "permissions.lua"
    "shared.lua"
    "windowrules.lua"
    "workspaces.lua"
    "hooks.lua"
  ];
in {
  imports = [
    ./hypridle.nix
    ./hyprland.nix
  ];

  home.file = builtins.listToAttrs (map (file: {
      name = ".config/hypr/${file}";

      value.source =
        if file == "hyprland.lua"
        then
          lib.mkForce (
            config.lib.file.mkOutOfStoreSymlink "${hyprDir}/${file}"
          )
        else config.lib.file.mkOutOfStoreSymlink "${hyprDir}/${file}";
    })
    files);
}
