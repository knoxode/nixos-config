{ host
, pkgs
, ...
}:
let
  inherit (import ../../hosts/${host}/variables.nix) printEnable;
in
{
  services = {
    printing = {
      enable = printEnable;
      # Legacy network-printer broadcast discovery; no queue needs it and it
      # is a repeated CVE source. CUPS is socket-activated anyway.
      browsed.enable = false;
      drivers = [
        pkgs.hplipWithPlugin
      ];
    };
    ipp-usb.enable = printEnable;
  };
}
