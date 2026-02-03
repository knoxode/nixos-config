{config, ...}: {
  systemd.user.services = {
    display_hotplug_monitor = {
      Unit = {
        Description = "A self-made display hotplugging monitor script";
      };
      Service = {
        ExecStart = "/home/${config.home.username}/.config/monitorHotplug/displayHotplugMonitor.sh";
      };
    };
  };
}
