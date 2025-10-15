# overlays/hyprlock.nix
self: super: {
  hyprlock = super.hyprlock.overrideAttrs (old: {
    version = "0.9.2";
    src = super.fetchFromGitHub {
      owner = "hyprwm";
      repo = "hyprlock";
      rev = "main";
      hash = "sha256-fu0B4duamVdbkPio/czu1XhsPLRXUJpZLDrSk3nih4U=";
    };
  });
}
