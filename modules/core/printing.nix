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
      drivers = [
        pkgs.hplipWithPlugin
      ];
    };
    ipp-usb.enable = printEnable;
  };
}
