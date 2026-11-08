{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        devices = ["nodev"];
        useOSProber = true;
      };
      efi.canTouchEfiVariables = true;
      timeout = 5;
    };
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
      kernelModules = ["dm-snapshot"];
      luks.devices.luks-root = {
        device = "/dev/disk/by-uuid/18259c3e-e044-4752-86ea-b5f79fd1463c";
      };
    };
    kernelParams = [
      "i915.force_probe=!7d45"
      "xe.force_probe=7d45"
    ];

    kernelModules = [
      "kvm-intel"
      "i2c-dev"
    ];
  };

  fileSystems."/" = {
    device = "/dev/vg/root";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1A2E-3DAB";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  swapDevices = [{device = "/dev/vg/swap";}];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
