{host, ...}: let
  inherit
    (import ../../hosts/${host}/variables.nix)
    forGaming
    hasRazer
    ;
in {
  imports =
    [
      ./avahi.nix
      ./cosmic.nix
      ./flatpak.nix
      ./greetd.nix
      ./i2c.nix
      ./nautilus-related.nix
      ./nh.nix
      ./openssh.nix
      ./packages.nix
      ./audio.nix
      ./printing.nix
      ./rstudio.nix
      ./security.nix
      ./sops.nix
      ./spicetify.nix
      ./starship.nix
      ./stylix.nix
      ./syncthing.nix
      ./system.nix
      ./tlp.nix
      ./upower.nix
      ./user.nix
      ./virtualisation.nix
      ./wireguard.nix
    ]
    ++ (
      if forGaming
      then [./steam.nix]
      else []
    )
    ++ (
      if hasRazer
      then [./rgb.nix]
      else []
    );
}
