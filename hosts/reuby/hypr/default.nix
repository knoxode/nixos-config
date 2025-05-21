{ host, lib, ... }:

{
  home-manager.users.shaiikura.home.file.".config/hypr/startupscripts" = lib.mkOverride 10 {
    source = ./startupscripts;
    recursive = true;
    executable = true;
  };
}

