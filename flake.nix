{
  description = "Alex's NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    hyprland.url = "github:hyprwm/Hyprland/a62ccb169aa05ef40c6c215c0638e843740920f3";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix/02098a8c4f373cb0b2f6691bab1fa2e921d6c123";
    stylix.url = "github:danth/stylix/master";

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvchad4nix = {
      url = "github:nix-community/nix4nvchad";
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
