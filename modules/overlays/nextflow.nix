# overlays/hyprlock.nix
self: super: {
  nextflow = super.nextflow.overrideAttrs (old: {
    version = "25.06.0-edge";
    src = super.fetchFromGitHub {
      owner = "nextflow-io";
      repo = "nextflow";
      rev = "7d9272b78edaceedd80beeb63b15ed78b27bfffc";
      hash = "sha256-OCTVCjUYy9/J+0Gu/yF3akXH8RbYlFZ+Cgdzaf0JzjA=";
    };
  });
}
