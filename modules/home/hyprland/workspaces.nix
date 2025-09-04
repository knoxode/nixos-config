{host, ...}: let
  inherit
    (import ../../../hosts/${host}/variables.nix)
    hostType
    leftMonitor
    centerMonitor
    ;

  #This file defines the workspaces for any given host. In the case of desktops where the number of monitors is likely to be static,
  #5 workspaces are set to persist, and the first of each five is made the default for each monitor.
  workspaceConfig =
    if hostType == "Desktop"
    then
      (
        builtins.concatLists [
          (map (
            n: let
              idx = toString n;
              isDefault = n == 1;
            in "${idx}, monitor:desc:${centerMonitor}, persistent:true${
              if isDefault
              then ", default:true"
              else ""
            }"
          ) (builtins.genList (n: n + 1) 5))

          (map (
            n: let
              idx = toString n;
              isDefault = n == 6;
            in "${idx}, monitor:desc:${leftMonitor}, persistent:true${
              if isDefault
              then ", default:true"
              else ""
            }"
          ) (builtins.genList (n: n + 6) 5))
        ]
      )
    else [];
in {
  wayland.windowManager.hyprland.settings = {
    workspace = workspaceConfig;
  };
}
