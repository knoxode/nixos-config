{
  config,
  pkgs,
  ...
}: {
  services = {
    printing = {
      enable = config.alexos.host.printing;
      # Legacy network-printer broadcast discovery; no queue needs it and it
      # is a repeated CVE source. CUPS is socket-activated anyway.
      browsed.enable = false;
      drivers = [
        pkgs.hplipWithPlugin
      ];
    };
    ipp-usb.enable = config.alexos.host.printing;
  };
}
