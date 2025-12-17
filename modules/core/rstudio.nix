{pkgs, ...}: {
  environment.etc."rstudio/rstudio-prefs.json".source = ../../preferences/rstudio-prefs.json;

  environment.systemPackages = [
    (pkgs.rstudioWrapper.override {
      packages = with pkgs.rPackages; [
        # ggplot2
        # dplyr
        #
        # xts
        # knitr
        # magrittr
        # rmarkdown
        # stringi
        # stringr
        # optparse
        #
        # ggVennDiagram
        # ggridges
        # showtext
        #
        # # BiocManager
        # clusterProfiler
        # DiffBind
        # csaw
      ];
    })
  ];
}
