{...}: {
  home.file = {
    ".config/monitorHotplug/reconcileMonitors.sh" = {
      source = ./reconcileMonitors.sh;
      executable = true;
    };
    ".config/monitorHotplug/handle_monitor_disconnect.sh" = {
      source = ./handle_monitor_disconnect.sh;
      executable = true;
    };
    ".config/monitorHotplug/handle_monitor_connect.sh" = {
      source = ./handle_monitor_connect.sh;
      executable = true;
    };
    ".config/monitorHotplug/displayHotplugMonitor.sh" = {
      source = ./displayHotplugMonitor.sh;
      executable = true;
    };
  };
}
