{
  host,
  inputs,
  pkgs,
  ...
}: let
  hostSecrets = {
    "syncthing/${host}/key" = {};
    "syncthing/${host}/cert" = {};
    "wireguard/${host}/privatekey" = {};
    "wireguard/${host}/i6privatekey" = {};
  };

  commonSecrets = {
    "wireguard/publickey" = {};
    "wireguard/presharedkey" = {};
    "geldoc" = {};
    "eduroam/cert" = {
      path = "/etc/NetworkManager/certs/eduroam.pem";
      mode = "0444";
    };
    "eduroam/env" = {};
  };
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  environment.systemPackages = with pkgs; [
    sops
  ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age = {
      keyFile = "/home/shaiikura/.config/sops/age/keys.txt";
    };
    secrets = commonSecrets // hostSecrets;
  };
}
