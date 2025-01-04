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
  home-manager.users.shaiikura.home.file.".config/hypr/handle_monitor_connect.sh" = {
    source = ./handle_monitor_connect.sh;
    executable = true;
  };
  home-manager.users.shaiikura.home.file.".config/hypr/handle_monitor_disconnect.sh" = {
    source = ./handle_monitor_disconnect.sh;
    executable = true;
  };
  home-manager.users.shaiikura.home.file.".config/hypr/start_monitor.sh" = {
    source = ./start_monitor.sh;
    executable = true;
  };
  home-manager.users.shaiikura.home.file.".config/hypr/2_workspace.sh" = {
    source = ./2_workspace.sh;
    executable = true;
  };
}
