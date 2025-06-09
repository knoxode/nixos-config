# overlays/hyprlock.nix
self: super: {
  hyprlock = super.hyprlock.overrideAttrs (old: {
    version = "0.8.2";
    src = super.fetchFromGitHub {
      owner = "hyprwm";
      repo = "hyprlock";
      rev = "main";
      hash = "sha256-aCiNnE26qIAxEBP6SRXjLBlIGOB18TViDreoPe96p6Q=";
    };
  });
}
