{
  host,
  lib,
  config,
  pkgs,
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

  peerPublicKey = "DGMiYEvjkaG37zQfxbAisvjAnKGkT5D7p8YqdcN/xn4=";
  endpointHost = "vpn.tha.haus";
  endpointPort = 51821;
  fwMark = 51820;
  ipBin = "${pkgs.iproute2}/bin/ip";

  peerAllowedIPs =
    gatewayIPs
    ++ peerIPs
    ++ lanIPs
    ++ additionalIPs;

  # The IPv6 default belongs in the policy-routing table, not main: the
  # native default must stay intact so WireGuard's own (marked) outer
  # packets can reach an IPv6 endpoint.
  nonDefaultAllowedIPs = builtins.filter (ip: ip != "::/0") peerAllowedIPs;

  routeLine = ip:
    if lib.hasInfix ":" ip
    then ''${ipBin} -6 route replace "${ip}" dev wg0 table main''
    else ''${ipBin} route replace "${ip}" dev wg0 table main'';

  endpointSelector = pkgs.writeShellApplication {
    name = "wg-endpoint-select";

    runtimeInputs = with pkgs; [
      coreutils
      gawk
      getent
      gnugrep
      iproute2
      iputils
      util-linux
      wireguard-tools
    ];

    runtimeEnv = {
      WG_IFACE = "wg0";
      WG_PEER = peerPublicKey;
      WG_HOSTNAME = endpointHost;
      WG_PORT = toString endpointPort;
      WG_FW_MARK = toString fwMark;
      WG_PSK_FILE = config.sops.secrets."wireguard/presharedkey".path;
      WG_ALLOWED_IPS = lib.concatStringsSep "," peerAllowedIPs;
      WG_KEEPALIVE = "25";
      # The inner gateway; used only to generate tunnel traffic so the
      # candidate endpoint's handshake can be verified.
      WG_PROBE_IP = "10.8.0.2";
      WG_STATE_DIR = "/run/wireguard-endpoint";
      WG_HANDSHAKE_MAX_AGE = "240";
      WG_V6_HOLD_SECONDS = "600";
    };

    text = builtins.readFile ./wireguard-endpoint.sh;
  };

  dispatcher = pkgs.writeShellApplication {
    name = "wg-endpoint-dispatcher";
    runtimeInputs = [
      pkgs.coreutils
      config.systemd.package
    ];
    text = builtins.readFile ./wireguard-dispatcher.sh;
  };
in {
  systemd.services = {
    "wireguard-wg0-peer-${vpnConnectionName}_i6" = {
      # Wait for network-online: NetworkManager-wait-online makes
      # network-online.target track real connectivity before the selector
      # tries the first endpoint.
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 5;
        # The endpoint is owned by the selector. Run it synchronously after
        # the peer unit has installed the peer, so the first keepalive uses
        # the family the current link can actually carry.
        ExecStartPost = ["-${lib.getExe endpointSelector} --reset-hold"];
      };
    };

    # Periodic safety net for a blackholed path whose route still exists.
    # NetworkManager dispatcher events cover link/address/connectivity
    # changes; this only acts when the current handshake has gone stale.
    wg-endpoint-select = {
      description = "Select the WireGuard endpoint family from the live underlay";
      after = ["wireguard-wg0.service" "network-online.target"];
      wants = ["network-online.target"];
      unitConfig = {
        StartLimitIntervalSec = 0;
      };
      serviceConfig = {
        Type = "oneshot";
        ExecStart = lib.getExe endpointSelector;
      };
    };
  };

  systemd.timers.wg-endpoint-select = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "60s";
      OnUnitActiveSec = "60s";
      AccuracySec = "10s";
    };
  };

  systemd.targets = {
    # The generated target makes the peer service a member (wants+after), and
    # target completion requires its members — which serialized multi-user
    # behind wifi association (the peer waits for network-online). Keep the
    # target gating on wg0.service only; the peer still starts with the
    # interface (wanted by wireguard-wg0.service) and self-gates on
    # network-online, out of the boot-critical path.
    "wireguard-wg0" = {
      wants = lib.mkForce ["wireguard-wg0.service"];
      after = lib.mkForce ["wireguard-wg0.service"];
    };
  };

  environment.etc."NetworkManager/dispatcher.d/30-wg-endpoint" = {
    source = dispatcher;
    mode = "0555";
  };

  networking = {
    wireguard.enable = true;

    wireguard.interfaces = {
      wg0 = {
        ips = selfIP;
        listenPort = 1235;
        mtu = 1420;
        fwMark = toString fwMark;

        # The interface routes are installed below so ::/0 can go into its
        # own table. Main keeps only the specific peer/LAN routes.
        allowedIPsAsRoutes = false;

        privateKeyFile =
          config.sops.secrets."wireguard/${host}/i6privatekey".path;

        postSetup = ''
          ${lib.concatMapStringsSep "\n" routeLine nonDefaultAllowedIPs}
          ${ipBin} -6 route replace "::/0" dev wg0 table ${toString fwMark}
          ${ipBin} -6 rule del pref 32764 2>/dev/null || true
          ${ipBin} -6 rule del pref 32765 2>/dev/null || true
          ${ipBin} -6 rule add pref 32764 table main suppress_prefixlength 0
          ${ipBin} -6 rule add pref 32765 not fwmark ${toString fwMark} table ${toString fwMark}
        '';

        preShutdown = ''
          ${ipBin} -6 rule del pref 32764 2>/dev/null || true
          ${ipBin} -6 rule del pref 32765 2>/dev/null || true
        '';

        peers = [
          {
            name = "${vpnConnectionName}_i6";

            publicKey = peerPublicKey;

            presharedKeyFile =
              config.sops.secrets."wireguard/presharedkey".path;

            # Endpoint is set by wg-endpoint-select: NixOS/wg resolves a
            # hostname only once and takes the first getaddrinfo result, which
            # cannot express an IPv6 preference with IPv4 fallback.
            persistentKeepalive = 25;

            allowedIPs = peerAllowedIPs;
          }
        ];
      };
    };
  };
}
