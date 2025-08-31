# overlays/hyprlock.nix
self: super: {
  hyprlock = super.hyprlock.overrideAttrs (old: {
    version = "0.9.0";
    src = super.fetchFromGitHub {
      owner = "hyprwm";
      repo = "hyprlock";
      rev = "main";
      hash = "sha256-KttBtdPHDCuD+BT0da8DmBarv6k+9GA9INpeDLLgpc8=";
    };
  });
}
