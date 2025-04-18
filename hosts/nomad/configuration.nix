# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./hardware-specific/hardware-specific.nix

      # host-specific overrides
      ./services/syncthing.nix
      ./services/monitor_script.nix
      ./hypr/override.nix

      #Bluetooth
      ./../../modules/nixos/hardware/hardware.nix

      # Services imports
      ./../../modules/nixos/services/services.nix

      # Programs imports
      ./../../modules/nixos/programs/programs.nix

      #Steam import
      ./../../modules/nixos/programs/steam.nix

      # User imports
      ./../../modules/nixos/users/users.nix
 
      # Package imports
      ./../../modules/nixos/packages/packages.nix

  ];

  system.stateVersion = "25.05"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  

  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  # Bootloader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    devices = [ "nodev" ];
    useOSProber = true;
  };

  networking.networkmanager.enable = true;
  networking.hostName = "nomad"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";
  security.rtkit.enable = true;


  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = true;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = true;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      reverseSync.enable = true;
    };
  };
  environment.systemPackages = with pkgs; [
    nvtopPackages.full
  ];
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;

      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 40;

      START_CHARGE_THRESH_BAT0 = 50;
      STOP_CHARGE_THRESH_BAT0 = 80;

     # #Optional helps save long term battery health
     # START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
     # STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
     #
    };
  }; 
}
