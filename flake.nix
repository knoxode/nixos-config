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
    hyprland.url = "github:hyprwm/Hyprland/775111b6032185c9ef164d7ba1417a875c1d0287";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nur, nix-flatpak, spicetify-nix, ... }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; config.permittedInsecurePackages = [ "openssl-1.1.1w" ]; overlays = [ nur.overlays.default ]; };
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
            substituters = ["https://hyprland.cachix.org"];
            trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
          };
        }
        {
          nixpkgs.overlays = [inputs.hyprpanel.overlay];
        }
        nix-flatpak.nixosModules.nix-flatpak
      ];
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
    };
}

