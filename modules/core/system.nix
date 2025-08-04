{
  host,
  pkgs,
  inputs,
  ...
}: {
  console.keyMap = "uk";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };
  networking.hostName = host;
  nix = {
    settings = {
      auto-optimise-store = true;
      download-buffer-size = 524288000;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
  };
  nixpkgs.config = {
    permittedInsecurePackages = ["openssl-1.1.1w"];
  };
  nixpkgs.overlays = [
    (import ../overlays/hyprlock.nix)
    (import ../overlays/mesa.nix)
    #(import ../overlays/nextflow.nix)
    inputs.nur.overlays.default
    inputs.nix-vscode-extensions.overlays.default
    (final: prev: let
      masterPkgs = import inputs.master-pkgs {
        system = final.system;
        config.allowUnfree = true; # if needed
      };
    in {
      clisp = masterPkgs.clisp;
    })
  ];
  security.sudo.wheelNeedsPassword = false;
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };
  system.stateVersion = "25.05"; # Do not change!
  time.timeZone = "Europe/London";
}
