# overlays/hyprlock.nix
self: super: {
  hyprlock = super.hyprlock.overrideAttrs (old: {
    version = "0.9.0";
    src = super.fetchFromGitHub {
      owner = "hyprwm";
      repo = "hyprlock";
      rev = "main";
      hash = "sha256-jYV+vPzfii7HSr3RSHMMP8msjvljsfOQd6JWpKjgLuw=";
    };
  });
}
