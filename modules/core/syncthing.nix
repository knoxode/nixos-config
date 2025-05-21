{ 
  host,
  lib,
  ...
}:
let
  nodePartners = [ "sync-home" "reuby" "nomad" ];
  nomadPartners = [ "sync-home" "reuby" "node" ];
  reubyPartners = [ "sync-home" "node" "nomad" ];

  allDevices = {
    "sync-home" = {
      id = "PVXSOYM-HYHTATF-LOSJWGS-D56LCFN-6UY5RSV-IF3LXUB-F77RLLL-S4DNDAU";
      addresses = [ "dynamic" ];
    };
    "reuby" = {
      id = "ZZ3X74O-NOFZLCB-TKKZTNR-3UWURQ7-ALFVILU-SR2WBAF-FVC7N4G-POGKYQA";
      addresses = [ "dynamic" ];
    };
    "nomad" = {
      id = "442IKN5-X36PPVX-KZU62YC-GJLTE6B-KJI4UHH-WVC3SX5-IRJ3NIV-JIGTGQO";
      addresses = [ "dynamic" ];
    };
    "node" = {
      id = "U4TPYUD-46RNTQA-3CBHJDP-CS256ZW-2YUWR3J-F3L3XD3-HALBNV2-HPIQ3AG";
      addresses = [ "dynamic" ];
    };
  };

  partners =
    if host == "node" then nodePartners
    else if host == "nomad" then nomadPartners
    else if host == "reuby" then reubyPartners
    else [ "sync-home" ];

  selectedDevices = lib.genAttrs partners (name: allDevices.${name});
in {
  services.syncthing = lib.mkDefault {
    enable = true;
    dataDir = "/home/shaiikura";
    user = "shaiikura";
    key = "/run/secrets/syncthing/${host}/key";
    cert = "/run/secrets/syncthing/${host}/cert";
    settings = {
      gui = {
        user = "shaiikura";
        password = "$2b$10$vLxAG0mJNZ//pQ4o.MaQlO5bZVqsDGZCM.wnsSdKdxy/ohd1upkBK";
      };
      devices = selectedDevices;
      folders = {
        "Alex's Shared Resources" = {
          id = "axar4-mmmgm";
          path = "/home/shaiikura/Documents/syncthing/asr";
          devices = partners;
        };
        "Family Photos" = {
          id = "nazam-5czbx";
          path = "/home/shaiikura/Documents/syncthing/fp";
          devices = partners;
        };
        "Whole House Sharing" = {
          id = "x4hhk-olcfd";
          path = "/home/shaiikura/Documents/syncthing/whs";
          devices = partners;
        };
        "Obsidian" = {
          id = "esuad-snwkk";
          path = "/home/shaiikura/Documents/syncthing/obsidian";
          devices = partners;
        };
      };
    };
  };
}

