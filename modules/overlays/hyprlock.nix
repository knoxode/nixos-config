# overlays/hyprlock.nix
self: super: {
  hyprlock = super.hyprlock.overrideAttrs (old: {
    version = "0.9.2";
    src = super.fetchFromGitHub {
      owner = "hyprwm";
      repo = "hyprlock";
      rev = "main";
      hash = "sha256-1hIq5gSfV0xc7gaBQDVk3XPv47vjhlc8qbAskOqT4b0=";
    };
  });
}
