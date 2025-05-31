{host, ...}: let
  selfIP =
    if host == "reuby"
    then ["10.7.0.5/32"]
    else if host == "nomad"
    then ["10.7.0.4/32"]
    else if host == "node"
    then ["10.7.0.3/32"]
    else [];
  vpnConnectionName = "${host}_split";
in {
  # Enable wireguard
  networking.wireguard.enable = true;
  #networking.networkmanager.insertNameservers = [ "192.168.1.118" ];
  networking.wireguard.interfaces = {
    wg0 = {
      ips = selfIP;
      listenPort = 1235; # to match firewall allowedUDPPorts (without this wg uses random port numbers)
      mtu = 1360;
      privateKeyFile = "/run/secrets/wireguard/${host}/privatekey";
      peers = [
        {
          presharedKeyFile = "/run/secrets/wireguard/presharedkey";
          publicKey = "xp86oULOebte00nmBkBtt7Blq2HwBJqR/pxfVdE7ECo=";
          allowedIPs = ["10.7.0.1/32" "10.7.0.3/32" "192.168.1.0/24" "192.168.10.0/24" "192.168.20.0/24" "192.168.30.0/24" "192.168.40.0/24" "10.10.10.0/24"] ++ selfIP;
          name = vpnConnectionName;
          endpoint = "knoxode.duckdns.org:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
