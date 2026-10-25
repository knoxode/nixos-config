{
  host,
  ...
}: let
  inherit (import ../../hosts/${host}/variables.nix) hostType;
in {
  # OpenRGB's device polling (~700 wakeups/s) keeps the CPU out of deep
  # package C-states, costing ~5 W on the laptop for no benefit — the Razer
  # keyboard runs through openrazer below. Desktop (node) keeps it.
  services.hardware.openrgb.enable = hostType == "Desktop";
  hardware.openrazer = {
    enable = true;
    users = [ "shaiikura" ];
  };
}
