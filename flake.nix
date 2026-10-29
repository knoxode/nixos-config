{
  description = "Alex's NixOS flake";

  inputs = {
    # Channel tarball: only ever resolves to a published (fully Hydra-built)
    # rev, so lock updates can't outrun cache.nixos.org. See update-flake.yml
    # and README.md.
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    firefox = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Keep its own nixpkgs: overlays.pinned serves packages built from the
    # input's own unstable-small tree, not ours.
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
