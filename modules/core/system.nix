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
    # Keep direnv devshell outputs and derivations alive across GC; without
    # these, nix-direnv shells rebuild every time nh-clean runs (weekly).
    settings = {
      keep-outputs = true;
      keep-derivations = true;
    };

    # The NixOS default writes /etc/nix/registry.json with `to.type = "path"`
    # pointing at the system nixpkgs, embedding the full nixpkgs source
    # (~1.5 GiB) in the system closure. Point the registry at the same channel
    # tarball URL the flake input uses instead; consumers (`nix search
    # nixpkgs`, `nix run nixpkgs#...`) fetch it over the network on first use.
    registry.nixpkgs.to = {
      type = "tarball";
      url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    };
    settings = {
      auto-optimise-store = true;
      download-buffer-size = 524288000;
      # Explicitly list trusted users; do not rely on the module default
      # ["root"] merging in. Trusted users may pass --option substituters /
      # trusted-public-keys from non-root clients (nh refuses to run as root).
      trusted-users = lib.mkForce ["root" "shaiikura"];
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
  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.pinned
    inputs.nur.overlays.default
  ];
  # The graphical-desktop module enables the speech-dispatcher *service* by
  # default (mkDefault true), which drags espeak-ng + mbrola-voices + flite
  # (~700 MiB) into the closure for a screen reader that isn't installed.
  # Apps that link libspeechd (Firefox, Discord) only need the library, which
  # is a separate build and unaffected.
  services.speechd.enable = false;
  security.sudo.wheelNeedsPassword = false;
  # Don't let one straggler service hold shutdown hostage for 90s.
  systemd.settings.Manager.DefaultTimeoutStopSec = "10s";
  services.journald.settings.Journal.SystemMaxUse = "1G";
  # Skip building the NixOS manual on every switch; nothing here reads it.
  documentation.nixos.enable = false;
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
