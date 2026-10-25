{
  pkgs,
  options,
  ...
}: {
  imports = [
    ./networkProfiles/eduroam.nix
  ];

  systemd.network.wait-online.enable = false;

  networking = {
    networkmanager.enable = true;

    timeServers =
      options.networking.timeServers.default
      ++ ["pool.ntp.org"];

    firewall = {
      enable = true;

      allowedTCPPorts = [
        22
        80
        443
        59010
        59011
        8080
      ];

      allowedUDPPorts = [
        51820
        1235
        59010
        59011
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
  ];
}
