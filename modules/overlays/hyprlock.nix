# overlays/hyprlock.nix
self: super: {
  hyprlock = super.hyprlock.overrideAttrs (old: {
    version = "0.8.2";
    src = super.fetchFromGitHub {
      owner = "hyprwm";
      repo = "hyprlock";
      rev = "main";
      hash = "sha256-KX7nCVTBEMy75mTqZG/GadOSP717HhVv2aSc1sGPTx8=";
    };
  });
}
