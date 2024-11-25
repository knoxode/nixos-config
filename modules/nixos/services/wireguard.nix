{ lib, ... }:

{
  
  networking.firewall = lib.mkDefault {
    allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
  };
  # Enable WireGuard
  networking.wireguard.enable = true;
  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    let
      listenPort = 51820;
      privateKeyFile = "/home/shaiikura/.config/sops/age/keys.txt";
      peers = [
        publicKey = {};
        endpoint = {server-ip}:51820;
        persistentKeepalive;
      ];
    in 


    wg0 = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = [ "10.100.0.2/24" ];
      peers = [
        {
          # Forward all the traffic via VPN.
          allowedIPs = [ "0.0.0.0/0" ];
        }
      ];
    };
  };
}
