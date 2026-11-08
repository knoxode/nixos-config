{
  lib,
  hostConfig,
  config,
  ...
}: let
  displayHotPlugMonitor =
    if hostConfig.hotplugMonitor
    then {
      display_hotplug_monitor = {
        Unit = {
          Description = "A self-made display hotplugging monitor script";
          After = ["hyprland-session.target"];
          Requires = ["hyprland-session.target"];
        };
        Service = {
          ExecStart = "/home/${config.home.username}/.config/monitorHotplug/displayHotplugMonitor.sh";
          Restart = "always";
          RestartSec = 5;
        };
        Install = {
          WantedBy = ["hyprland-session.target"];
        };
      };
    }
    else {};
in {
  systemd.user.services = displayHotPlugMonitor;
}
