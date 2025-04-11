{ pkgs, lib, ... }:

{
  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.type = "simple";
  };

  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-goodix;
    };
  };
}
