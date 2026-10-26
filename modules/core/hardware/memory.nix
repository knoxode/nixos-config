{...}: {
  zramSwap = {
    enable = true;
  };

  # zram-generator upstream recommendations: swap eagerly into compressed RAM
  # rather than holding anonymous pages until heavy pressure, and disable
  # read-ahead (fetching extra pages into zram is wasteful).
  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.page-cluster" = 0;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
  };
}
