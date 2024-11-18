{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    syncthing
  ];

  services.syncthing = {
    enable = true;
    dataDir = "/home/shaiikura";
    user = "shaiikura";
    # key = "";
    # cert = "";
    settings = {
      gui = {
        user = "shaiikura";
        password = "test";
      };
    };
  };
}
