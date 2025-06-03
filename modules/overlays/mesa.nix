# overlays/mesa.nix
self: super: {
  mesa = super.mesa.overrideAttrs (old: {
    version = "25.1.1";
    src = super.fetchFromGitLab {
      owner = "mesa";
      repo = "mesa";
      rev = "mesa-25.1.1";
      sha256 = "13jsraci4x4xcgw3683vd8ar0nfwk8fnpd0snz770p7wn09nqkjn";
    };
  });
}
