{
  host,
  lib,
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
      substituters = ["https://hyprland.cachix.org" "https://winapps.cachix.org/" "https://noctalia.cachix.org" "https://attic.xuyh0120.win/lantian"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz8+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" "winapps.cachix.org-1:HI82jWrXZsQRar/PChgIx1unmuEsiQMQq+zt05CD36g=" "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="];
    };
  };
  nixpkgs.config = {
    permittedInsecurePackages = ["openssl-1.1.1w" "electron-40.10.5"];
  };
  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.pinned
    inputs.nur.overlays.default
    inputs.nix-vscode-extensions.overlays.default
    (import ./overlays/wireshark.nix)
    # (final: prev: let
    #   oldPkgs = import inputs.nixpkgs-snapgene {
    #     system = final.system;
    #     config.allowUnfree = true; # if needed
    #   };
    # in {
    #   SnapGene = oldPkgs.SnapGene;
    # })
  ];
  security.sudo.wheelNeedsPassword = false;
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };
  system.stateVersion = "25.05"; # Do not change!
  time = {
    timeZone = lib.mkDefault "Europe/London";
    hardwareClockInLocalTime = true;
  };
}
