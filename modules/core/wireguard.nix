{
  host,
  lib,
  config,
  ...
}: let
  # WireGuard addresses assigned to each host
  hostIPs = {
    reuby = [
      "10.8.0.5/32"
      "2a06:61c1:5a28:70::5/128"
    ];

    nomad = [
      "10.8.0.4/32"
      "2a06:61c1:5a28:70::4/128"
    ];

    node = [
      "10.8.0.3/32"
      "2a06:61c1:5a28:70::3/128"
    ];
    oppo = [
      "10.8.0.8/32"
      "2a06:61c1:5a28:70::8/128"
    ];
  };

  # WireGuard gateway addresses
  gatewayIPs = [
    "10.8.0.1/32"
    "10.8.0.2/32"
  ];

  # Local network devices and subnets
  lanIPs = [
    "192.168.1.21/32"
    "192.168.1.43/32"
    "192.168.1.118/32"
    "192.168.10.0/24"
    "192.168.20.0/24"
    "192.168.30.0/24"
    "192.168.40.0/24"
    "10.10.10.0/24"
  ];

  # Additional routes
  additionalIPs = [
    "::/0"
  ];

  # Addresses assigned to the current host
  selfIP = hostIPs.${host} or [];

  # Addresses belonging to all other hosts
  peerIPs = builtins.concatLists (
    builtins.attrValues (
      removeAttrs hostIPs [host]
    )
  );

  vpnConnectionName = "${host}_split";
in {
  systemd.services = {
    # Wait-online serializes the whole boot behind link-up for a peer that
    # self-heals via retry + keepalive. Boot stops blocking on connectivity.
    NetworkManager-wait-online.enable = false;

    "wireguard-wg0-peer-${vpnConnectionName}_i6" = {
      # The endpoint is an FQDN; if the tunnel comes up before NM has a
      # route, retry instead of having held the boot hostage for it.
      wants = lib.mkForce [];
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };

  networking = {
    wireguard.enable = true;

    wireguard.interfaces = {
      wg0 = {
        ips = selfIP;
        listenPort = 1235;
        mtu = 1420;

        privateKeyFile =
          config.sops.secrets."wireguard/${host}/i6privatekey".path;

        peers = [
          {
            name = "${vpnConnectionName}_i6";

            publicKey = "DGMiYEvjkaG37zQfxbAisvjAnKGkT5D7p8YqdcN/xn4=";

            presharedKeyFile =
              config.sops.secrets."wireguard/presharedkey".path;

            endpoint = "i6vpn.tha.haus:51821";
            persistentKeepalive = 25;

            allowedIPs =
              gatewayIPs
              ++ peerIPs
              ++ lanIPs
              ++ additionalIPs;
          }
        ];
      };
    };
  };
}
