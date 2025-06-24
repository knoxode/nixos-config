{host, ...}: let
  inherit
    (import ../../hosts/${host}/variables.nix)
    forGaming
    hasRazer
    hostType
    ;
in {
  imports =
    [
      ./avahi.nix
      ./bluetooth.nix
      ./flatpak.nix
      ./greetd.nix
      ./i2c.nix
      ./icons.nix
      ./nautilus-related.nix
      ./network.nix
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
      ./systemd.nix
      ./tlp.nix
      ./upower.nix
      ./user.nix
      ./virtualisation.nix
      ./wireguard.nix
    ]
    ++ (
      if forGaming
      then [./steam.nix ./gamemode.nix ./coolercontrol.nix]
      else []
    )
    ++ (
      if hasRazer
      then [./rgb.nix]
      else []
    )
    ++ (
      if hostType == "Desktop"
      then []
      else [./tlp.nix]
    );
}
