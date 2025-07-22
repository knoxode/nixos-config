# overlays/hyprlock.nix
self: super: {
  hyprlock = super.hyprlock.overrideAttrs (old: {
    version = "0.9.0";
    src = super.fetchFromGitHub {
      owner = "hyprwm";
      repo = "hyprlock";
      rev = "main";
      hash = "sha256-X7aKppxc/SsNmzDs9pIUp8+t0QRUmswSQgbGqqm0aK0=";
    };
  });
}
