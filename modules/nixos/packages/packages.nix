{ pkgs, ... }:

{
  hardware.openrazer.enable = true;
  environment.systemPackages = with pkgs; [

      #Terminal-related
      rustc
      cargo
      unzip
      git
      starship
      jetbrains-mono
      tree
      tmux
      fish
      python3
      python3Packages.pip
      superfile

      #Desktop-related
      google-chrome
      flatpak
      mission-center

      #Gaming-related
      mangohud
      gamemode

      # ags
      brightnessctl
      fastfetch
      os-prober
      powertop

      #Office-related
      gimp
      inkscape
      libreoffice
      teams-for-linux

      #Development environments
      direnv
      nix-direnv

      #Organisation related
      obsidian
      #Partially imperative, check the OneDrive Nixos documentation
      # onedrive
      onedrivegui

      #hyprland-related
      hyprpanel
      hyprlock
      hyprpicker
      hypridle
      hyprsunset
      rofi
      swww
      waypaper
      grim
      grimblast
      slurp
      swappy
      wlogout
      jq
      socat

      #Disk management
      gparted

      #wireguard
      networkmanagerapplet

      #openssl
      openssl

      #keyboard-related
      openrazer-daemon
      polychromatic

  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "DroidSansMono" ]; })
  ];
}

