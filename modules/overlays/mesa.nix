# overlays/mesa.nix
self: super: {
  mesa = super.mesa.overrideAttrs (old: {
    version = "25.1.5";
    src = super.fetchFromGitLab {
      owner = "mesa";
      repo = "mesa";
      rev = "mesa-25.1.5";
      sha256 = "0p8s7nvnc8zg2p36mmwg4kpwmbx73gd9nqksjmscgkr2zkbiv401";
    };
  });
}
