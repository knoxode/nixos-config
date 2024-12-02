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
        };
        folders = {
          "Alex's Shared Resources" = {
            id = "axar4-mmmgm";
            path = "/home/shaiikura/Documents/syncthing/asr";
            devices = [ "sync-home" "nomad" ];
          };
          "Family Photos" = {
            id = "nazam-5czbx";
            path = "/home/shaiikura/Documents/syncthing/fp";
            devices = [ "sync-home" "nomad" ];
          };
          "Whole House Sharing" = {
            id = "x4hhk-olcfd";
            path = "/home/shaiikura/Documents/syncthing/whs";
            devices = [ "sync-home" "nomad" ];
          };
        };
      };
    }
  ];
}

