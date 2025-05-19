{ pkgs, ... }:

{
  services.printing = {
    enable = true;
    fprintd.enable = true;
    drivers = [ pkgs.hplipWithPlugin ];
  };

  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };

}
