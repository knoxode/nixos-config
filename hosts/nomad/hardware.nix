{
  lib,
  pkgs,
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
      timeout = 2;
    };
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = [];
    };
    # Hibernation: resume from the /var/lib/swapfile (see swapDevices below).
    # resumeDevice is the partition holding it; resume_offset is its first
    # 4K block. If the swapfile is ever deleted+recreated, recompute with:
    #   sudo filefrag -v /var/lib/swapfile | sed -n '4p'
    resumeDevice = "/dev/disk/by-uuid/723eb7d0-f5f2-4324-b196-b755d7510174";
    kernelParams = [
      "resume_offset=39563264"
    ];
    kernelModules = [
      "kvm-intel"
    ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/723eb7d0-f5f2-4324-b196-b755d7510174";
    fsType = "ext4";
    # Access-time bookkeeping buys nothing here; drop the metadata churn.
    options = ["noatime"];
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
