{ pkgs, lib, ... }:

{

  environment.systemPackages = with pkgs; [
    syncthing
  ];

  services.syncthing = lib.mkDefault {
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
      devices = {
        "sync-home" = { id = "PVXSOYM-HYHTATF-LOSJWGS-D56LCFN-6UY5RSV-IF3LXUB-F77RLLL-S4DNDAU"; addresses = [ "dynamic" ]; };
      };
      folders = {
        "Alex's Shared Resources" = {
          id = "axar4-mmmgm";
          path = "/home/shaiikura/Documents/syncthing/asr";
          devices = [ "sync-home"];
        };
        "Family Photos" = {
          id = "nazam-5czbx";
          path = "/home/shaiikura/Documents/syncthing/fp";
          devices = [ "sync-home" ];
        };
        "Whole House Sharing" = {
          id = "x4hhk-olcfd";
          path = "/home/shaiikura/Documents/syncthing/whs";
          devices = [ "sync-home" ];
        };
        "Obsidian" = {
          id = "esuad-snwkk";
          path = "/home/shaiikura/Documents/syncthing/obsidian";
          devices = [ "sync-home" ];
        };
      };
    };
  };
}

