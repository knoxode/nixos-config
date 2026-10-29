{...}: {
  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  # /tmp in RAM: faster temp IO (nix builds, opencode), no SSD wear. Large
  # spill goes to zram, not disk.
  boot.tmp.useTmpfs = true;

  # The cachyos kernel enables zswap by default. It front-runs zram,
  # compressing into its own pool and spilling pre-compressed pages into
  # zram on writeback. Disable it so zram is the first-class backend.
  # transparent_hugepage=always: CachyOS-style gaming default; bigger
  # anonymous pages suit game allocations on 16 GiB machines.
  boot.kernelParams = [
    "zswap.enabled=0"
    "transparent_hugepage=always"
  ];

  # zram-generator upstream recommendations: swap eagerly into compressed RAM
  # rather than holding anonymous pages until heavy pressure, and disable
  # read-ahead (fetching extra pages into zram is wasteful). Pressure 50
  # keeps the dentry/inode cache under pressure; stat_interval 10 trades VM
  # stat granularity for fewer timer wakeups.
  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.page-cluster" = 0;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.vfs_cache_pressure" = 50;
    "vm.stat_interval" = 10;
  };
}
