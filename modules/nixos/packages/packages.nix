{ pkgs, ... }:

{
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

      #Desktop-related
      google-chrome
      flatpak

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
      onedrive

      #hyprland-related
      hyprpanel
      rofi
      swww
      waypaper
      grim
      grimblast
      hyprpicker
      slurp
      swappy
      hyprlock
      wlogout
      jq
      socat

      #wireguard
      networkmanagerapplet

      #openssl
      openssl

  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "DroidSansMono" ]; })
  ];
}

