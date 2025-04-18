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
  home-manager.users.shaiikura.home.file.".config/hypr/env.conf" = lib.mkOverride 10 {
    source = ./env.conf;
    executable = true;
  };
  home-manager.users.shaiikura.home.file.".config/hypr/monitor_script.sh" = {
    source = ./monitor_script.sh;
    executable = true;
  };
  home-manager.users.shaiikura.home.file.".config/hypr/2_workspace.sh" = {
    source = ./2_workspace.sh;
    executable = true;
  };
}


