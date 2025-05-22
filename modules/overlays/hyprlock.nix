# overlays/hyprlock.nix
self: super: {
  hyprlock = super.hyprlock.overrideAttrs (old: {
    version = "0.8.2";
    src = super.fetchFromGitHub {
      owner = "hyprwm";
      repo = "hyprlock";
      rev = "main";
      hash = "sha256-IypoV7crmhQ4llD0n4qqO4XTRNAAbHfA+2oiTiq2qpk=";
    };
  });
}

