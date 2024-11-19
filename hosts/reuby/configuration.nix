# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # host-specific overrides
      ./../../hosts/reuby/services/syncthing.nix

      # Services imports
      ./../../modules/nixos/services/openssh.nix
      ./../../modules/nixos/services/printing.nix
      ./../../modules/nixos/services/syncthing-defaults.nix
      ./../../modules/nixos/services/common-xserver.nix
      ./../../modules/nixos/services/pipewire.nix
      ./../../modules/nixos/services/hyprland.nix

      # Programs imports
      ./../../modules/nixos/programs/starship.nix
      ./../../modules/nixos/programs/firefox.nix
      ./../../modules/nixos/programs/sops.nix
      ./../../modules/nixos/programs/rstudio.nix
  ];

  system.stateVersion = "24.05"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.shaiikura = {
    isNormalUser = true;
    description = "Alex Ryder";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDfRPyTbfUwQ/3V94NfCQ+dNzr9N4MQaRkxsXIqSXp1z powerskater3@gmail.com"
    ];
    packages = with pkgs; [
      starship
    ];
  };

  environment.systemPackages = with pkgs; [
      git
      starship
      jetbrains-mono
      tree
      google-chrome
      ags
      brightnessctl
      fastfetch
      os-prober
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # Bootloader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    # efiSupport = true;
    devices = [ "/dev/vda" ];
    useOSProber = true;
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
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
}
