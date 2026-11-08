{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./networkProfiles/eduroam.nix
  ];

  systemd.network.wait-online.enable = false;

  # Local DNS cache on 127.0.0.53; NM switches its dns mode automatically.
  services.resolved.enable = true;

  networking = {
    networkmanager = {
      enable = true;
      # Per-host: battery (roaming laptops) vs latency (desktop).
      wifi.powersave = config.alexos.host.wifiPowersave;
    };
    # No WWAN modem on any fleet host; NM's default enable only ships the
    # ModemManager stack and an inactive service.
    modemmanager.enable = false;

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
