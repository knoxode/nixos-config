{system, lib, config, ... }:

{
  systemd.user.services.monitor-watcher = {
    Unit = {
      Description = "Monitor event capture script";
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "/home/shaiikura/.config/hypr/scripts/monitor_script.sh";
      Restart = "always";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
