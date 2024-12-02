{
  services.syncthing = {
      key = "/run/secrets/syncthing/nomad/key";
      cert = "/run/secrets/syncthing/nomad/cert";
    settings = {
      devices = {
        "sync-home" = { id = "PVXSOYM-HYHTATF-LOSJWGS-D56LCFN-6UY5RSV-IF3LXUB-F77RLLL-S4DNDAU"; addresses = [ "dynamic" ]; };
        "reuby" = {id = "ZZ3X74O-NOFZLCB-TKKZTNR-3UWURQ7-ALFVILU-SR2WBAF-FVC7N4G-POGKYQA"; addresses = [ "dynamic" ]; };
      };
      folders = {
        "Alex's Shared Resources" = {
          devices = [ "sync-home" "reuby" ];
        };
        "Family Photos" = {
          devices = [ "sync-home" "reuby" ];
        };
        "Whole House Sharing" = {
          devices = [ "sync-home" "reuby" ];
        };
      };
    };
  };
}

{ lib, ... }:

{
  services.syncthing = lib.mkMerge [
    {
      key = "/run/secrets/syncthing/reuby/key";
      cert = "/run/secrets/syncthing/reuby/cert";
      settings = {
        devices = {
          "sync-home" = { id = "PVXSOYM-HYHTATF-LOSJWGS-D56LCFN-6UY5RSV-IF3LXUB-F77RLLL-S4DNDAU"; addresses = [ "dynamic" ]; };
          "reuby" = {id = "ZZ3X74O-NOFZLCB-TKKZTNR-3UWURQ7-ALFVILU-SR2WBAF-FVC7N4G-POGKYQA"; addresses = [ "dynamic" ]; };
        };
        folders = {
          "Alex's Shared Resources" = {
            id = "axar4-mmmgm";
            path = "/home/shaiikura/Documents/syncthing/asr";
            devices = [ "sync-home" "reuby" ];
          };
          "Family Photos" = {
            id = "nazam-5czbx";
            path = "/home/shaiikura/Documents/syncthing/fp";
            devices = [ "sync-home" "reuby" ];
          };
          "Whole House Sharing" = {
            id = "x4hhk-olcfd";
            path = "/home/shaiikura/Documents/syncthing/whs";
            devices = [ "sync-home" "reuby" ];
          };
        };
      };
    }
  ];
}

