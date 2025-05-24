{ host
, inputs
, pkgs
, ...
}:
let
  hostSecrets = {
    "syncthing/${host}/key" = { };
    "syncthing/${host}/cert" = { };
    "wireguard/${host}/privatekey" = { };
  };

  commonSecrets = {
    "wireguard/publickey" = { };
    "wireguard/presharedkey" = { };
    "geldoc" = { };
  };
in
{
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
