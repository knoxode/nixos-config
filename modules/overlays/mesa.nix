# overlays/mesa.nix
self: super: {
  mesa = super.mesa.overrideAttrs (old: {
    version = "25.1.7";
    src = super.fetchFromGitLab {
      owner = "mesa";
      repo = "mesa";
      rev = "mesa-25.1.7";
      sha256 = "0dkn9mpczl2iam0ijvczzk9n621v42f6k0h190rwnblz90fqrivn";
    };
  });
}
