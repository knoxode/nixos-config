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
      substituters = [
        "https://hyprland.cachix.org"
        "https://winapps.cachix.org/"
        "https://noctalia.cachix.org"
        # xddxdd's CachyOS kernel binary cache. Rotated to a new URL/key on
        # 2026-10-24 after the Oct 15 server compromise; see upstream issue
        # xddxdd/nix-cachyos-kernel#110.
        "https://cache.lantian.pub/lantian"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz8+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "winapps.cachix.org-1:HI82jWrXZsQRar/PChgIx1unmuEsiQMQq+zt05CD36g="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        "lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ="
      ];
    };
  };
  nixpkgs.config = {
    permittedInsecurePackages = ["openssl-1.1.1w" "electron-40.10.5"];
  };
  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.pinned
    inputs.nur.overlays.default
    inputs.nix-vscode-extensions.overlays.default
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
