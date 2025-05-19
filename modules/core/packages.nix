{ 
  pkgs,
  ... 
}:


{
  programs = {
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    firefox.enable = true;
    fish.enable = true;
    hyprland.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    #Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.droid-sans-mono
    nerd-fonts.symbols-only
  ];

  environment.systemPackages = with pkgs; [
    # Terminal-related
    nvchad
    rustc
    cargo
    unzip
    git
    starship
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
    nextflow
    temurin-bin-17
    sshfs-fuse
    conda
    helix
    htop
    kitty
    starship

    #music-related
    easyeffects
      
    # Desktop-related
    syncthing
    mendeley
    wl-clipboard
    cifs-utils
    google-chrome
    flatpak
    nautilus
    kdePackages.dolphin
    kdePackages.gwenview
    lxqt.lxqt-policykit
    vlc
    beeper
    jellyfin-media-player

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
    igv

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

    # Miscellaneous tools
    brightnessctl
    fastfetch
    os-prober
    powertop
    power-profiles-daemon
    lm_sensors

    # Disk management
    gparted

    # OpenSSL
    openssl

    # Keyboard-related
    openrazer-daemon
    polychromatic

    # Virtualisation-related
    virtiofsd


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

    # General python packages
    python313Packages.dbus-python
  ];
}

