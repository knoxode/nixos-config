{
  pkgs,
  ...
}: {
  # Fleet-wide CachyOS BORE LTO kernel: one scheduler choice everywhere, and
  # the nvidia RTD3 patch (profiles/nvidia-laptop) targets this 7.3 series.
  boot.kernelPackages =
    pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v3;

  # lz4 decompresses the initrd roughly twice as fast as zstd, shaving boot
  # time; the archive grows ~30% but lives transiently in RAM.
  boot.initrd.compressor = "lz4";
}
