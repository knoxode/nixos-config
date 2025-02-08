{ pkgs, ... }:

{
  hardware.openrazer.enable = true;

  environment.systemPackages = with pkgs; [
    # Terminal-related
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
    clang
    vulkan-tools
    vulkan-headers
    vulkan-loader
    vulkan-validation-layers

    #music-related
    easyeffects
      
    # Desktop-related
    google-chrome
    flatpak
    mission-center
    nautilus

    # Gaming-related
    prismlauncher
    mangohud
    gamemode
    discord-canary
    lutris

    # Office-related
    gimp
    inkscape
    libreoffice
    mupdf
    anydesk

    # Development environments
    direnv
    nix-direnv

    # Organisation related
    obsidian
    # Partially imperative, check the OneDrive NixOS documentation
    # onedrive
    onedrivegui

    # Hyprland-related
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
    pywal

    # Miscellaneous tools
    brightnessctl
    fastfetch
    os-prober
    powertop
    power-profiles-daemon

    # Disk management
    gparted

    # Wireguard
    networkmanagerapplet

    # OpenSSL
    openssl

    # Keyboard-related
    openrazer-daemon
    polychromatic

    # Virtualisation-related
    virtiofsd

    #Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.droid-sans-mono
  ];
}

