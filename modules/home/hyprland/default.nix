{...}: {
  imports = [
    ./hypridle.nix
    ./hyprland.nix
  ];
  home.file = let
    files = [
      ./animations.lua
      ./appearance.lua
      ./binds.lua
      ./devices.lua
      ./env.lua
      ./exec.lua
      ./gpu.lua
      ./hyprland.lua
      ./layouts.lua
      ./misc.lua
      ./monitors.lua
      ./permissions.lua
      ./shared.lua
      ./windowrules.lua
      ./workspaces.lua
    ];
  in
    builtins.listToAttrs (map (f: {
        name = ".config/hypr/${baseNameOf f}";
        value.source = f;
      })
      files);
}
