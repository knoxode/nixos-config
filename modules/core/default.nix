{
  host,
  ...
}:
let
   inherit (import ../../hosts/${host}/variables.nix)
   forGaming
   ;
in {
  imports = [
    ./avahi.nix
    ./common-xserver.nix
    ./cosmic.nix
    ./flatpak.nix
    ./greetd.nix
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
  ] ++ (if forGaming then [ ./steam.nix ] else [])
  ;
}
