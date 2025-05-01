# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./hardware-specific/hardware-specific.nix

      # host-specific overrides
      ./services/syncthing.nix
      ./services/sched_ext.nix
      ./hypr/override.nix
      #Bluetooth
      ./../../modules/nixos/hardware/hardware.nix

      # Services imports
      ./../../modules/nixos/services/services.nix
      # Programs imports
      ./../../modules/nixos/programs/programs.nix

      # environment imports
      ./../../modules/nixos/environment/environment.nix

      # User imports
      ./../../modules/nixos/users/users.nix
 
      # Package imports
      ./../../modules/nixos/packages/packages.nix
  ];

  system.stateVersion = "25.05"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos;

    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        devices = [ "nodev" ];
        useOSProber = true;
      };
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };

    initrd = {
      verbose = false;
      luks.devices.luks-root = {
        device = "/dev/disk/by-uuid/18259c3e-e044-4752-86ea-b5f79fd1463c";
        preLVM = true;
      };
    };

    plymouth = {
      enable = true;
      theme = "dna";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "dna" ];
        })
      ];
    };

    consoleLogLevel = 3;

    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };

  networking.networkmanager.enable = true;
  networking.hostName = "reuby"; # Define your hostname.

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

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

    # Start the driver at boot
  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };

  # services.tlp = {
  #   enable = true;
  #   settings = {
  #
  #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #
  #     CPU_ENERGY_PERF_POLICY_ON_BAT = "balance-power";
  #     CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
  #
  #     CPU_MIN_PERF_ON_AC = 0;
  #     CPU_MAX_PERF_ON_AC = 100;
  #
  #     #Optional helps save long term battery health
  #     START_CHARGE_THRESH_BAT0 = 50; # Charges when below 75
  #     STOP_CHARGE_THRESH_BAT0 = 80; # Stops charging at 80
  #
  #     #Regulates the state of Intel Dynamic Boosting - 1 is allowed, 0 is disallowed.
  #     CPU_HWP_DYN_BOOST_ON_AC=1;
  #     CPU_HWP_DYN_BOOST_ON_BAT=0;
  #
  #   };
  # }; 


# Install the driver
  services.fprintd.enable = true;
  # If simply enabling fprintd is not enough, try enabling fprintd.tod...
  # services.fprintd.tod.enable = true;
  # ...and use one of the next four drivers
  # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix; # Goodix driver module
  # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-elan; # Elan(04f3:0c4b) driver
  # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090; # driver for 2016 ThinkPads
  # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix-550a; # Goodix 550a driver (from Lenovo)

  # however for focaltech 2808:a658, use fprintd with overidden package (without tod)
  # services.fprintd.package = pkgs.fprintd.override {
  #   libfprint = pkgs.libfprint-focaltech-2808-a658;
  # };

  
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
}
