{
  host,
  pkgs,
  lib,
  ...
}: let
  selfIP =
    if host == "reuby"
    then ["10.7.0.5/32"]
    else if host == "nomad"
    then ["10.7.0.4/32"]
    else if host == "node"
    then ["10.7.0.3/32"]
    else [];

  selfIPstring = builtins.head selfIP;

  allClientIPs = [
    "10.7.0.2/32" # Oneplus
    "10.7.0.3/32" # Node
    "10.7.0.4/32" # Nomad
    "10.7.0.5/32" # Reuby
  ];

  allowedPeerIPs = builtins.filter (ip: ip != selfIPstring) allClientIPs;

  vpnConnectionName = "${host}_split";
in {
  networking = {
    wireguard.enable = true;

    wireguard.interfaces = {
      wg0 = {
        ips = selfIP;
        listenPort = 1235;
        mtu = 1360;
        privateKeyFile = "/run/secrets/wireguard/${host}/privatekey";
        peers = [
          {
            presharedKeyFile = "/run/secrets/wireguard/presharedkey";
            publicKey = "kjkXw+oCZqNPHB/m9GxOg2urWTH58f02jxvsBVD6SDY=";
            allowedIPs =
              [
                "10.7.0.1/32"
                "192.168.1.43/32"
                "192.168.1.118/32"
                "192.168.10.0/24"
                "192.168.20.0/24"
                "192.168.30.0/24"
                "192.168.40.0/24"
                "10.10.10.0/24"
              ]
              ++ selfIP
              ++ allowedPeerIPs;
            name = vpnConnectionName;
            endpoint = "knoxvpn.duckdns.org:51820";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
  systemd.services."wireguard-wg0".unitConfig = {
    Wants = ["sops-install-secrets.service"];
    After = ["sops-install-secrets.service"];
  };
}
