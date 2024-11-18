{  inputs, pkgs, lib, config, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  
  environment.systemPackages = with pkgs; [
    sops
  ];

  sops = {
    defaultSopsFile = ./../../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age = {
      keyFile = "/home/shaiikura/.config/sops/age/keys.txt";
    };
    secrets = {
      "syncthing/nomad/key" = {};
      "syncthing/nomad/cert" = {};
    };
  };
}
