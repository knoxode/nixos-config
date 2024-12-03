{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-24.11 branch
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
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
    nur.url = "github:nix-community/NUR";
    hyprland.url = "github:hyprwm/Hyprland";

    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";

    ags.url = "github:aylur/ags";

    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";

    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = { self, nixpkgs, home-manager, nur, nixos-cosmic, nix-flatpak, ... }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; config.permittedInsecurePackages = [ "openssl-1.1.1w" ]; overlays = [ nur.overlay ]; };
      extraSpecialArgs = { inherit system; inherit inputs; };
      specialArgs = { inherit system; inherit inputs; };
      common-modules = [
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            inherit extraSpecialArgs;
            useGlobalPkgs = true;
            useUserPackages = true;
            users.shaiikura = import ./modules/home-manager/shaiikura.nix;
            backupFileExtension = "backup";
          };
        }
        {
          nix.settings = {
            substituters = [ "https://cosmic.cachix.org/" ];
            trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
          };
        }
        {
          nixpkgs.overlays = [inputs.hyprpanel.overlay];
        }
        nixos-cosmic.nixosModules.default
        nix-flatpak.nixosModules.nix-flatpak

      ];
      agsConfig = import ./ags-devshell.nix { inherit pkgs system inputs; };
    in { 
      nixosConfigurations.nomad = lib.nixosSystem {
        inherit system pkgs specialArgs;
        modules = common-modules ++ [
          ./hosts/nomad/configuration.nix
        ];
      };
      nixosConfigurations.reuby = lib.nixosSystem {
        inherit system pkgs specialArgs;
        modules = common-modules ++ [
          ./hosts/reuby/configuration.nix
        ];
      };

      # Include AGS-specific devShells
      devShells = agsConfig.devShells;
    };
}

