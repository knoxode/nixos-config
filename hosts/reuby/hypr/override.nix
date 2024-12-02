{ lib, ... }:

{
  home-manager.users.shaiikura.home.file.".config/hypr/general.conf" = lib.mkOverride 10 {
    source = ./general.conf;
  };
}

