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
  peerKey = "DGMiYEvjkaG37zQfxbAisvjAnKGkT5D7p8YqdcN/xn4=";
  endpointPort = 51821;
  endpointNames = {
    both = "vpn.tha.haus"; # A + AAAA, resolves to the same gateway either way
  };

  # Endpoint-family selector. WireGuard resolves its Endpoint hostname once
  # (first getaddrinfo hit) and has no fallback, so to prefer v6 when the
  # native link actually carries v6 and fall back to v4 otherwise we set the
  # endpoint to a resolved literal:
  #
  #   1. v6 candidate: the AAAA of i6vpn.tha.haus (= vpn.tha.haus AAAA).
  #      Probed over the *native* v6 default route (routes owned by wg0 are
  #      excluded): a tunnel routing ::/0 could otherwise answer the probe
  #      itself while native v6 is dead, making the v6 choice permanently
  #      sticky on v4-only networks.
  #   2. v4 fallback: the A of vpn.tha.haus, probed directly (0.0.0.0/0 is
  #      not in allowedIPs, so this always travels the native link).
  #   3. Both fail: leave the current endpoint alone; persistentKeepalive
  #      keeps retrying.
  #
  # Called by the NM dispatcher on connectivity events and as the peer
  # unit's ExecStartPost so boot selects the family the link actually has.
  wgEndpointSelect = pkgs.writeShellScript "wg-endpoint-family-select" ''
    ip="${pkgs.iproute2}/bin/ip"
    ping="${pkgs.iputils}/bin/ping"
    wg="${pkgs.wireguard-tools}/bin/wg"
    getent="${pkgs.getent}/bin/getent"
    curl="${pkgs.curl.bin}/bin/curl"
    port="${toString endpointPort}"
    peer="${peerKey}"

    # Nothing to steer without the interface.
    "$ip" link show wg0 >/dev/null 2>&1 || exit 0
    "$wg" show wg0 peers 2>/dev/null | grep -qx "$peer" || exit 0

    # Short-circuit on a healthy tunnel: the selector's only job is bringing
    # a dead/stale tunnel to the right family (the dispatcher already fixes
    # the family on live link changes). A fresh handshake means recent
    # traffic went through; leave it alone.
    now="$("${pkgs.coreutils}/bin/date" +%s)"
    hs="$("$wg" show wg0 latest-handshakes 2>/dev/null |
      grep -F "$peer" | awk '{print $2; exit}')"
    if [ -n "''${now:-}" ] && [ -n "''${hs:-}" ] && [ "$hs" -ne 0 ] &&
      [ "$((now - hs))" -lt 180 ]; then
      exit 0
    fi

    # Lookup each family explicitly. The server address is assigned by the
    # gateway side and may be dynamic, so DNS is the only source of truth
    # for it -- no literal fallbacks. Two lookup paths, because the local
    # resolver can fail in opposite directions:
    #   - system resolver first: it may still answer from its cache when
    #     the hotspot resolver flaps, and it works on captive portals where
    #     egress to 1.1.1.1 is blocked until authentication.
    #   - DoH to 1.1.1.1 second: covers hostile/flapping local resolvers
    #     that leave port-53 answering but break real lookups (this
    #     hotspot). 1.1.1.1 is anycast and stable by construction; only the
    #     *lookup path* is pinned, never the server address.
    # If both paths fail, leave the endpoint alone this pass; the
    # dispatcher and the retry timer come back.
    v6lit=""
    v4lit=""
    if [ -n "$("$getent" ahostsv6 ${endpointNames.both})" ] &&
      [ -n "$("$getent" ahostsv4 ${endpointNames.both})" ]; then
      v6lit="$("$getent" ahostsv6 ${endpointNames.both} | awk '{print $1; exit}')"
      v4lit="$("$getent" ahostsv4 ${endpointNames.both} | awk '{print $1; exit}')"
    else
      a4="$("$curl" -fsS --max-time 3 \
        "https://1.1.1.1/dns-query?name=${endpointNames.both}&type=A" \
        -H "accept: application/dns-json" |
        grep -ioE '"type":1,"TTL":[0-9]*,"data":"[^"]*"' |
        head -1 | sed -n 's/.*"data":"\([^"]*\)"/\1/p')"
      a6="$("$curl" -fsS --max-time 3 \
        "https://1.1.1.1/dns-query?name=${endpointNames.both}&type=AAAA" \
        -H "accept: application/dns-json" |
        grep -ioE '"type":28,"TTL":[0-9]*,"data":"[^"]*"' |
        head -1 | sed -n 's/.*"data":"\([^"]*\)"/\1/p')"
      v4lit="$a4"
      v6lit="$a6"
    fi

    # Native v6: a default route not owned by wg0 plus an end-to-end
    # probe over that route's device.
    v6dev="$("$ip" -o -6 route show default 2>/dev/null |
      grep -v 'dev wg0 ' | head -1 |
      sed -n 's/.* dev \([^ ]*\) .*/\1/p')"
    if [ -n "''${v6dev:-}" ] && [ -n "$v6lit" ] &&
      "$ping" -6 -n -W1 -c1 -I "$v6dev" "$v6lit" >/dev/null 2>&1; then
      "$wg" set wg0 peer "$peer" endpoint "[$v6lit]:$port"
      exit 0
    fi

    if [ -n "$v4lit" ] &&
      "$ping" -4 -n -W1 -c1 "$v4lit" >/dev/null 2>&1; then
      "$wg" set wg0 peer "$peer" endpoint "$v4lit:$port"
    fi
    # Both families unreachable: no change; keepalive keeps retrying.
  '';

  # NetworkManager dispatcher: runs outside the boot graph on connection
  # lifecycle events, so protocol migration happens the moment the link
  # changes (wifi<->ethernet, v6 appearing/disappearing, suspend/resume).
  wgDispatcherHook = pkgs.writeShellScript "wg-endpoint-family-dispatcher" ''
    case "$2" in
      up|connectivity-change|dhcp4-change|dhcp6-change|reapply)
        exec ${wgEndpointSelect}
        ;;
    esac
    exit 0
  '';
in {
  systemd.services = {
    "wireguard-wg0-peer-${vpnConnectionName}_i6" = {
      # Wait for network-online: NetworkManager-wait-online makes
      # network-online.target track real connectivity, so the FQDN endpoint
      # resolves on the first attempt. The retry policy only covers a
      # resolvectl that starts slower than the wifi association.
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 5;
        # Re-select the endpoint family synchronously after wg set: on
        # v4-only networks a v6-only default would otherwise be trusted
        # until the next dispatcher event.
        ExecStartPost = [ "${wgEndpointSelect}" ];
      };
    };

    # DNS-only endpoint indirection means the selector can only act when the
    # resolver actually answers. The dispatcher re-runs it on link events;
    # this timer covers the gap: when the tunnel is dead or stale (the
    # selector's own short-circuit skips healthy state), retry every ~2 min
    # so the family swap happens in minutes rather than waiting for the next
    # DHCP cycle or a link churn.
    "wireguard-wg0-endpoint-select" = {
      description = "endpoint-family re-selection (retry when the tunnel is stale)";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${wgEndpointSelect}";
      };
    };
  };

  systemd.timers = {
    "wireguard-wg0-endpoint-select" = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "90s";
        OnUnitActiveSec = "2min";
        AccuracySec = "30s";
      };
    };
  };

  environment.etc."NetworkManager/dispatcher.d/30-wg-endpoint-families" = {
    # NM dispatcher runs scripts asynchronously (outside the boot graph, no
    # boot-time serialization), root-owned and 0755+ executable.
    source = wgDispatcherHook;
    mode = "0555";
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
