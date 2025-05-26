{ host, ... }:

let
  inherit
    (import ../../../hosts/${host}/variables.nix)
    hostType
    leftMonitor
    centerMonitor
    ;

  workspaceConfig = if hostType == "Desktop" then
    (
      builtins.concatLists [
        (map (n:
          let
            idx = toString n;
            isDefault = n == 1;
          in
            "${idx}, monitor:desc:${centerMonitor}, persistent:true${if isDefault then ", default:true" else ""}"
        ) (builtins.genList (n: n + 1) 5))

        (map (n:
          let
            idx = toString n;
            isDefault = n == 6;
          in
            "${idx}, monitor:desc:${leftMonitor}, persistent:true${if isDefault then ", default:true" else ""}"
        ) (builtins.genList (n: n + 6) 5))
      ]
    )
  else
    (map (n: "${toString n}, persistent:true") (builtins.genList (n: n + 1) 10));
in {
  wayland.windowManager.hyprland.settings = {
      workspace = workspaceConfig;
  };
}
