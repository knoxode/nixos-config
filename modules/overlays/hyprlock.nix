# overlays/hyprlock.nix
self: super: {
  hyprlock = super.hyprlock.overrideAttrs (old: {
    version = "0.9.0";
    src = super.fetchFromGitHub {
      owner = "hyprwm";
      repo = "hyprlock";
      rev = "main";
      hash = "sha256-RO2h4H9KeFo1DUA6/J8WUTbaTRg7XBzkFJorwVdGMU4=";
    };
  });
}
