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
      ./auto-update.nix
      ./bluetooth.nix
      ./hardware
      ./gpu_symlink.nix
      ./i2c.nix
      ./nautilus-related.nix
      ./network.nix
      ./nh.nix
      ./noctalia-greeter.nix
      ./openssh.nix
      ./packages.nix
      ./audio.nix
      ./power-settings.nix
      ./printing.nix
      ./security.nix
      ./sops.nix
      ./spicetify.nix
      ./stylix.nix
      ./syncthing.nix
      ./system.nix
      ./systemd.nix
      ./timezoned.nix
      ./upower.nix
      ./user.nix
      ./virtualisation.nix
      ./wireguard.nix
      ./wireshark.nix
      ./zsh.nix
    ]
    ++ (
      if forGaming
      then [./steam.nix ./gamemode.nix ./gamescope.nix]
      else []
    )
    ++ (
      if hasRazer
      then [./rgb.nix]
      else []
    )
    ++ (
      if hostType == "Desktop"
      then [
        ./nvidia-container-toolkit.nix
        # Desktop-only: coolercontrold keeps a persistent NVML handle to the
        # NVIDIA GPU, which blocks RTD3 runtime suspend entirely. Laptops
        # (nomad) keep their dGPU in D3cold instead; node doesn't use RTD3.
        ./coolercontrol.nix
      ]
      else []
    );
}
