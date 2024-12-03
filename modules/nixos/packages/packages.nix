{ pkgs, ... }:

let
  snapgeneVersion = "8.0.1";
  snapgeneSha256 = "1lm607jk7i3zdlqj2rg3dhg6p1dshy4xygcxx8scnzh60l0q3xi0";
  snapgene = pkgs.stdenv.mkDerivation {
    pname = "snapgene";
    version = snapgeneVersion;

    src = pkgs.fetchurl {
      url = "https://cdn.snapgene.com/downloads/SnapGene/8.x/8.0/8.0.1/snapgene_${snapgeneVersion}_linux.deb";
      sha256 = snapgeneSha256;
    };

    unpackPhase = ''
      ar x $src
      tar -xf data.tar.xz
    '';

    installPhase = ''
      mkdir -p $out/bin
      ln -s $out/opt/gslbiotech/snapgene/snapgene $out/bin/snapgene
    '';

    meta = with pkgs.lib; {
      description = "SnapGene - Molecular Biology Software";
      homepage = "https://www.snapgene.com";
      license = licenses.unfree;
      platforms = platforms.linux;
    };
  };
in{
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

      #Compiling(?)
      # autoconf
      # automake
      # libtool
      # pkg-config
      # m4

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
      wlogout

      #wireguard
      networkmanagerapplet

      snapgene
  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];
}
