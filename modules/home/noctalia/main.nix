{
  host,
  lib,
  ...
}: let
  inherit (import ../../../hosts/${host}/variables.nix) hostType;
  clockSet = {
    id = "Clock";
    formatHorizontal = "dddd | MMM dd yyyy | HH:mm";
    usePrimaryColor = true;
  };

  hostDepBattery =
    if hostType == "Desktop"
    then {}
    else {
      id = "Battery";
      "showPowerProfiles" = true;
      "showNoctaliaPerformance" = true;
    };
in {
  programs.noctalia = {
    enable = true;
    settings = builtins.readFile ./config.toml;
  };
}
