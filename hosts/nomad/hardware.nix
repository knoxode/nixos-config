{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;

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
      verbose = false;
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = [];
    };
    kernel.sysctl = {
      "vm.swappiness" = 10;
    };
    kernelParams = [
    ];
    kernelModules = [
      "kvm-intel"
    ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/723eb7d0-f5f2-4324-b196-b755d7510174";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/54C2-C17F";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
}
