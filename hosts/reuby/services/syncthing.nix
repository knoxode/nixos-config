{ lib, ... }:

{
  services.syncthing = lib.mkMerge [
    {
      key = "/run/secrets/syncthing/reuby/key";
      cert = "/run/secrets/syncthing/reuby/cert";
      settings = {
        devices = {
          "nomad" = { id = "442IKN5-X36PPVX-KZU62YC-GJLTE6B-KJI4UHH-WVC3SX5-IRJ3NIV-JIGTGQO"; addresses = [ "dynamic" ]; };
          "sync-home" = { id = "PVXSOYM-HYHTATF-LOSJWGS-D56LCFN-6UY5RSV-IF3LXUB-F77RLLL-S4DNDAU"; addresses = [ "dynamic" ]; };
          "node" = { id = "U4TPYUD-46RNTQA-3CBHJDP-CS256ZW-2YUWR3J-F3L3XD3-HALBNV2-HPIQ3AG"; addresses = [ "dynamic" ]; };
        };
        folders = {
          "Alex's Shared Resources" = {
            id = "axar4-mmmgm";
            path = "/home/shaiikura/Documents/syncthing/asr";
            devices = [ "sync-home" "nomad" "node" ];
          };
          "Family Photos" = {
            id = "nazam-5czbx";
            path = "/home/shaiikura/Documents/syncthing/fp";
            devices = [ "sync-home" "nomad" "node" ];
          };
          "Whole House Sharing" = {
            id = "x4hhk-olcfd";
            path = "/home/shaiikura/Documents/syncthing/whs";
            devices = [ "sync-home" "nomad" "node" ];
          };
          "Obsidian" = {
            id = "esuad-snwkk";
            path = "/home/shaiikura/Documents/syncthing/obsidian";
            devices = [ "sync-home" "nomad" "node" ];
          };
        };
      };
    }
  ];
}

