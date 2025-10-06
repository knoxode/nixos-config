# overlays/hyprlock.nix
self: super: {
  hyprlock = super.hyprlock.overrideAttrs (old: {
    version = "0.9.0";
    src = super.fetchFromGitHub {
      owner = "hyprwm";
      repo = "hyprlock";
      rev = "main";
      hash = "sha256-o+r44fqPQM+/hQdjFy9qV9C51Jhty6M4icFVYocyJfA=";
    };
  });
}
