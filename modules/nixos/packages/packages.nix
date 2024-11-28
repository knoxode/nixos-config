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
      
      #Desktop-related
      google-chrome
      # ags
      brightnessctl
      fastfetch
      os-prober
      powertop
      
      #Office-related
      gimp
      inkscape
      libreoffice

      #Compiling(?)
      # autoconf
      # automake
      # libtool
      # pkg-config
      # m4

      #Development environments
      direnv
      nix-direnv

  ];
}
