{ lib, ... }:

{
  home-manager.users.shaiikura.home.file.".config/hypr/general.conf" = lib.mkOverride 10 {
    source = ./general.conf;
    executable = true;
  };
  home-manager.users.shaiikura.home.file.".config/hypr/execs.conf" = lib.mkOverride 10 {
    source = ./execs.conf;
    executable = true;
  };
  home-manager.users.shaiikura.home.file.".config/hypr/handle_monitor_connect.sh" = lib.mkOverride 10 {
    source = ./handle_monitor_connect.sh;
    executable = true;
  };
  home-manager.users.shaiikura.home.file.".config/hypr/handle_monitor_disconnect.sh" = lib.mkOverride 10 {
    source = ./handle_monitor_disconnect.sh;
    executable = true;
  };
  home-manager.users.shaiikura.home.file.".config/hypr/start_monitor.sh" = lib.mkOverride 10 {
    source = ./start_monitor.sh;
    executable = true;
  };
  home-manager.users.shaiikura.home.file.".config/hypr/2_workspace.sh" = lib.mkOverride 10 {
    source = ./2_workspace.sh;
    executable = true;
  };
}

