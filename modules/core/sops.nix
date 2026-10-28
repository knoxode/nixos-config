{
  host,
  inputs,
  pkgs,
  ...
}: let
  hostSecrets = {
    "syncthing/${host}/key" = {};
    "syncthing/${host}/cert" = {};
    "wireguard/${host}/i6privatekey" = {};
  };

  commonSecrets = {
    "wireguard/presharedkey" = {};
    "geldoc" = {};
    # Fine-grained PAT used for GitHub API calls from this machine (opening
    # PRs, enabling auto-merge). Consumed by reading /run/secrets/github/token
    # directly; not an environment variable.
    "github/token" = {
      owner = "shaiikura";
      mode = "0400";
    };
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
