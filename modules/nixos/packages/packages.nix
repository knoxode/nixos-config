{ inputs, pkgs, ... }:

{
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
    ddcutil
    ddcui
    bash-language-server
    lsof
    busybox
    vscode-fhs

    #music-related
    easyeffects
      
    # Desktop-related
    cifs-utils
    google-chrome
    flatpak
    mission-center
    nautilus
    kdePackages.dolphin
    kdePackages.gwenview
    lxqt.lxqt-policykit
    inputs.zen-browser.packages."${system}".default
    vlc
    beeper

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
    wayvnc
    tigervnc

    # Miscellaneous tools
    brightnessctl
    fastfetch
    os-prober
    powertop
    power-profiles-daemon
    lm_sensors

    # Disk management
    gparted

    # Wireguard
    networkmanagerapplet
    wgnord

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

    # support both 32-bit and 64-bit applications
    wineWowPackages.stable

    # support 32-bit only
    wine
    openconnect

    # support 64-bit only
    (wine.override { wineBuild = "wine64"; })

    # support 64-bit only
    wine64

    # wine-staging (version with experimental features)
    wineWowPackages.staging

    # winetricks (all versions)
    winetricks

    # native wayland support (unstable)
    wineWowPackages.waylandFull
  ];
}

