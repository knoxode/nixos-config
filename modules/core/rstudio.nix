{pkgs, ...}: let
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
      DiffBind
      csaw
    ];
  };
in {
  environment.etc."rstudio/rstudio-prefs.json".source = ../../preferences/rstudio-prefs.json;

  environment.systemPackages = [
    rEnv
  ];
}
