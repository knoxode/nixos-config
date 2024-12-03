{ lib, ... }:

{
  services.syncthing = lib.mkMerge [
    {
      key = "/run/secrets/syncthing/node/key";
      cert = "/run/secrets/syncthing/node/cert";
      settings = {
        devices = {
          "sync-home" = { id = "PVXSOYM-HYHTATF-LOSJWGS-D56LCFN-6UY5RSV-IF3LXUB-F77RLLL-S4DNDAU"; addresses = [ "dynamic" ]; };
          "reuby" = {id = "ZZ3X74O-NOFZLCB-TKKZTNR-3UWURQ7-ALFVILU-SR2WBAF-FVC7N4G-POGKYQA"; addresses = [ "dynamic" ]; };
          "nomad" = { id = "442IKN5-X36PPVX-KZU62YC-GJLTE6B-KJI4UHH-WVC3SX5-IRJ3NIV-JIGTGQO"; addresses = [ "dynamic" ]; };
        };
        folders = {
          "Alex's Shared Resources" = {
            id = "axar4-mmmgm";
            path = "/home/shaiikura/Documents/syncthing/asr";
            devices = [ "sync-home" "reuby" "nomad" ];
          };
          "Family Photos" = {
            id = "nazam-5czbx";
            path = "/home/shaiikura/Documents/syncthing/fp";
            devices = [ "sync-home" "reuby" "nomad" ];
          };
          "Whole House Sharing" = {
            id = "x4hhk-olcfd";
            path = "/home/shaiikura/Documents/syncthing/whs";
            devices = [ "sync-home" "reuby" "nomad" ];
          };
          "Obsidian" = {
            id = "esuad-snwkk";
            path = "/home/shaiikura/Documents/syncthing/obsidian";
            devices = [ "sync-home" "reuby" "nomad" ];
          };
        };
      };
    }
  ];
}

