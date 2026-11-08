{...}: {
  # Use zswap (compressed cache in front of disk swap) instead of zram.
  # Recommended by kernel MM maintainers for systems with disk swap + hibernation.
  # zswap integrates with kernel memory management, provides automatic tiering,
  # handles incompressible data better, and supports hibernation.
  boot.zswap = {
    enable = true;
    compressor = "zstd"; # Best compression ratio for Nix builds
    maxPoolPercent = 25; # 25% of RAM (4GB on 16GB systems)
    shrinkerEnabled = true; # Auto-reclaim under pressure
  };

  # Disable zram (conflicts with zswap; zram doesn't support hibernation)
  zramSwap.enable = false;

  # /tmp in RAM: faster temp IO (nix builds, opencode), no SSD wear.
  # Large spill goes to zswap-backed swap, not disk directly.
  boot.tmp.useTmpfs = true;

  # transparent_hugepage=always: better for gaming/workloads with large allocations.
  boot.kernelParams = [
    "transparent_hugepage=always"
  ];

  # Sysctl tuned for zswap + SSD:
  # - swappiness=100: prefer swap over dropping cache on fast storage
  # - page-cluster=0: disable readahead (no locality in compressed swap)
  # - watermark_scale_factor=125: earlier reclaim
  # - vfs_cache_pressure=50: keep dentry/inode cache under pressure
  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
    "vm.page-cluster" = 0;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.vfs_cache_pressure" = 50;
    "vm.stat_interval" = 10;
  };
}
