{pkgs, ...}: let
  # rEnv: kept as reference for R project dev-shells — see the rPackages list
  # below for the derivation shape when creating per-project flake.nix shells.
  rEnv = pkgs.rstudioWrapper.override {
    packages = with pkgs.rPackages; [
      rio
      ggplot2
      dplyr

      xts
      knitr
      magrittr
      rmarkdown
      stringi
      stringr
      optparse

      ggVennDiagram
      ggridges
      showtext

      # BiocManager
      ChIPseeker
      txdbmaker
      GenomeInfoDb
      clusterProfiler
      csaw
    ];
  };
in {
  environment.etc."rstudio/rstudio-prefs.json".source = ../../preferences/rstudio-prefs.json;

  environment.systemPackages = [
    #rEnv
  ];
}
