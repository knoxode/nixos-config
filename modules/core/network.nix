{
  pkgs,
  options,
  ...
}: {
  systemd.network.wait-online.enable = false;

  networking = {
    networkmanager.enable = true;
    # No WWAN modem on any fleet host; NM's default enable only ships the
    # ModemManager stack and an inactive service.
    modemmanager.enable = false;

    timeServers =
      options.networking.timeServers.default
      ++ ["pool.ntp.org"];

    firewall = {
      enable = true;

      # Only what actually listens: sshd and the wg0 listen port. WireGuard
      # peers are reached via the i6 gateway's endpoint port (51821), which
      # is outbound-only; return traffic lands on 1235.
      allowedTCPPorts = [22];
      allowedUDPPorts = [1235];
    };
  };

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
  ];
}
