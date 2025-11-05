# overlays/hyprlock.nix
self: super: {
  hyprlock = super.hyprlock.overrideAttrs (old: {
    version = "0.9.2";
    src = super.fetchFromGitHub {
      owner = "hyprwm";
      repo = "hyprlock";
      rev = "main";
      hash = "sha256-Et1jNDB2d3e0b4okIKuyAMktECS+5hk+vMAA7X598ao=";
    };
  });
}
