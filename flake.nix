{
  description = "Alex's NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    firefox = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    stylix.url = "github:danth/stylix/master";

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    system = "x86_64-linux";
    username = "shaiikura";
  in {
    nixosConfigurations = {
      reuby = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          host = "reuby";
          profile = "intel";
        };
        modules = [./profiles/intel];
      };
      node = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          host = "node";
          profile = "nvidia";
        };
        modules = [./profiles/nvidia];
      };
      nomad = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          host = "nomad";
          profile = "nvidia-laptop";
        };
        modules = [./profiles/nvidia-laptop];
      };
    };
  };
}
