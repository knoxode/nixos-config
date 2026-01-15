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
      ./customOptions
      ./customPackages
      ./flatpak.nix
      ./greetd.nix
      ./gpu_symlink.nix
      ./i2c.nix
      ./icons.nix
      ./nautilus-related.nix
      ./network.nix
      ./nh.nix
      ./noctalia.nix
      ./openssh.nix
      ./packages.nix
      ./audio.nix
      ./printing.nix
      ./rstudio.nix
      ./security.nix
      ./sops.nix
      ./spicetify.nix
      ./stylix.nix
      ./syncthing.nix
      ./system.nix
      ./systemd.nix
      ./timezoned.nix
      ./tlp.nix
      ./upower.nix
      ./user.nix
      ./virtualisation.nix
      ./wireguard.nix
      ./wireshark.nix
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
      if host == "reuby"
      then []
      else []
    )
    ++ (
      if hostType == "Desktop"
      then [./nvidia-container-toolkit.nix]
      else [./tlp.nix]
    );
}
