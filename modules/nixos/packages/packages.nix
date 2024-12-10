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

      #Development environments
      direnv
      nix-direnv

      #Organisation related
      obsidian

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

  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];
}

