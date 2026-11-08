{
  description = "Alex's NixOS flake";

  inputs = {
    # Follow nixos-unstable branch HEAD directly. Daily lock PR + build gate
    # catch broken revs; failure analysis posts actionable PR comment with
    # overlay snippet. See docs/operations/ci.md "nixpkgs Channel Strategy".
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
    repoRoot = "/home/${username}/alexos";

    hosts = {
      reuby = ./profiles;
      node = ./profiles;
      nomad = ./profiles/nvidia-laptop;
    };

    mkHost = host: profile:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs username repoRoot host;
        };
        modules = [profile];
      };
  in {
    nixosConfigurations = nixpkgs.lib.mapAttrs mkHost hosts;

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
