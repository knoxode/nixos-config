{
  host,
  config,
  pkgs,
  lib,
  ...
}: let
  selfIP =
    if host == "reuby"
    then ["10.8.0.5/32" "2a06:61c1:5a28:70::5/128"]
    else if host == "nomad"
    then ["10.8.0.4/32" "2a06:61c1:5a28:70::4/128"]
    else if host == "node"
    then ["10.8.0.3/32" "2a06:61c1:5a28:70::3/128"]
    else [];

  selfIPstring = builtins.head selfIP;

  allClientIPs = [
    "10.7.0.2/32"
    "10.7.0.3/32"
    "10.8.0.4/32"
    #Nomad IPv6
    "2a06:61c1:5a28:70::4/128"
    "10.8.0.5/32"
    #Reuby IPv6
    "2a06:61c1:5a28:70::5/128"
    # Node IPv6
    "2a06:61c1:5a28:70::3/128"
  ];

  allowedPeerIPs =
    builtins.filter
    (ip: !(builtins.elem ip selfIP))
    allClientIPs;

  vpnConnectionName = "${host}_split";
in {
  networking = {
    wireguard.enable = true;

    wireguard.interfaces = {
      wg0 = {
        ips = selfIP;
        listenPort = 1235;
        mtu = 1420;
        privateKeyFile = config.sops.secrets."wireguard/${host}/i6privatekey".path;
        peers = [
          {
            presharedKeyFile = config.sops.secrets."wireguard/presharedkey".path;
            publicKey = "DGMiYEvjkaG37zQfxbAisvjAnKGkT5D7p8YqdcN/xn4=";
            allowedIPs =
              [
                "10.8.0.1/32"
                "192.168.1.43/32"
                "192.168.1.118/32"
                "192.168.10.0/24"
                "192.168.20.0/24"
                "192.168.30.0/24"
                "192.168.40.0/24"
                "10.10.10.0/24"
                "::/0"
              ]
              ++ selfIP
              ++ allowedPeerIPs;
            name = "${vpnConnectionName}_i6";
            endpoint = "knoxvpn.duckdns.org:51821";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
}
