{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    syncthing
  ];

  services.syncthing = {
    enable = true;
    dataDir = "/home/shaiikura";
    user = "shaiikura";
      key = "/run/secrets/syncthing/nomad/key";
      cert = "/run/secrets/syncthing/nomad/cert";
    settings = {
      gui = {
        user = "shaiikura";
        password = "$2b$10$vLxAG0mJNZ//pQ4o.MaQlO5bZVqsDGZCM.wnsSdKdxy/ohd1upkBK";
      };
      folders = {
        "Alex's Shared Resources" = {
          id = "Alex's Shared Resources";
          path = "/home/shaiikura/Documents/syncthing/asr";
        };
        "Family Photos" = {
          id = "Family Photos";
          path = "/home/shaiikura/Documents/syncthing/fp";
        };
        "Whole House Sharing" = {
          id = "Whole House Sharing";
          path = "/home/shaiikura/Documents/syncthing/whs";
        };
      };
    };
  };
}
