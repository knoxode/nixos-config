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
  home-manager.users.shaiikura.home.file.".config/hypr/keybinds.conf" = lib.mkOverride 10 {
    source = ./keybinds.conf;
    executable = true;
  };
  home-manager.users.shaiikura.home.file.".config/hypr/2_workspace.sh" = {
    source = ./2_workspace.sh;
    executable = true;
  };
}
