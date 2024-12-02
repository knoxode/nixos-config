{ lib, ... }:

{
  networking.firewall = {
    allowedUDPPorts = [ 51820 ]; # Allow UDP traffic on WireGuard's port
  };

  # Enable WireGuard
  networking.wireguard.enable = true;

  # Define common configuration in a `let` block
  let
      privateKeyFile = "/run/secrets/wireguard/nomad/privatekey";
      presharedKeyFile = "/run/secrets/wireguard/nomad/presharedkey";
      serverPublicKey = "replace-with-server-public-key";
      endpoint = "replace-with-server-ip:51820";
  in { 
    networking.wireguard.interfaces = lib.mkOverride {
      home_split = {
        ips = [ "10.7.0.4/24" ];
        listenPort = 51820;
        privateKeyFile = privateKeyFile;
        peers = [
          {
            publicKey = serverPublicKey;
            presharedKeyFile = presharedKeyFile;
            endpoint = endpoint;
            allowedIPs = [ "0.0.0.0/0" ];
            persistentKeepalive = 25;
          }
        ];
      };

      home = {
        ips = [ "10.7.0.4/24" ];
        listenPort = 51820;
        privateKeyFile = privateKeyFile;
        peers = [
          {
            publicKey = serverPublicKey;
            presharedKeyFile = presharedKeyFile;
            endpoint = endpoint;
            allowedIPs = [
              "192.168.0.0/24"
              "192.168.10.0/24"
              "192.168.20.0/24"
              "192.168.30.0/24"
              "192.168.40.0/24"
              "10.10.10.0/24"
            ];
            persistentKeepalive = 25;
          }
        ];
      };
    };
  }
}
