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
                "192.168.1.0/24"
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
        # postSetup = ''
        #   printf "nameserver 192.168.1.118" | ${pkgs.openresolv}/bin/resolvconf -a wg0 -m 0
        # '';
      };
    };

    # networkmanager.dispatcherScripts = [
    #   {
    #     type = "basic";
    #     source = pkgs.writeShellScript "nm-wg-policy" ''
    #       #!/bin/sh
    #       IFACE="$1"
    #       ACTION="$2"
    #
    #       case "$IFACE" in
    #         lo|wg0|docker*) exit 0;;
    #       esac
    #
    #       case "$ACTION" in
    #         up)
    #           PROFILE="''${CONNECTION_ID:-}"
    #           GATEWAY="''${IP4_GATEWAY:-$(nmcli -t -f IP4.GATEWAY device show "$IFACE" 2>/dev/null | cut -d: -f2)}"
    #
    #           HOME_WIRED_PROFILE="Wired connection 1"
    #           HOME_GATEWAY="10.10.10.1"
    #           BLOCKED_SSIDS="A+H Nucleus Nucleus-Private"
    #
    #           block=0
    #
    #           if [ "$PROFILE" = "$HOME_WIRED_PROFILE" ] && [ "$GATEWAY" = "$HOME_GATEWAY" ]; then
    #             block=1
    #           fi
    #
    #           if nmcli -t -f GENERAL.TYPE device show "$IFACE" 2>/dev/null | grep -q ':wifi$'; then
    #             for s in $BLOCKED_SSIDS; do
    #               [ "$PROFILE" = "$s" ] && block=1
    #             done
    #           fi
    #
    #           if [ "$block" -eq 1 ]; then
    #             touch /run/no-wireguard
    #             systemctl stop wireguard-wg0.service
    #           else
    #             rm -f /run/no-wireguard
    #             systemctl start wireguard-wg0.service
    #           fi
    #           ;;
    #         down|pre-down)
    #           rm -f /run/no-wireguard
    #           ;;
    #       esac
    #     '';
    #   }
    # ];
  };

  # # Prevent WireGuard from auto-starting, gate on /run/no-wireguard
  # systemd.targets."wireguard-wg0".wantedBy = lib.mkForce [];
  # systemd.services."wireguard-wg0".unitConfig = {
  #   ConditionPathExists = "!/run/no-wireguard";
  #   After = ["NetworkManager.service" "NetworkManager-wait-online.service"];
  #   Wants = ["NetworkManager-wait-online.service"];
  # };
}
