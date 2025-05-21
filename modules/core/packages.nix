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
    virt-manager.enable = true;
    starship.enable = true;
  };

  fonts.packages = with pkgs; [
    #Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.droid-sans-mono
    nerd-fonts.symbols-only
  ];

  environment.systemPackages = with pkgs; [
    # Terminal-related
    anydesk
    bash-language-server
    beeper
    brightnessctl
    cargo
    cifs-utils
    clang
    conda
    ddcui
    ddcutil
    direnv
    discord-canary
    easyeffects
    fastfetch
    flatpak
    fish
    gamemode
    gimp
    git
    grim
    greetd.tuigreet
    grimblast
    gparted
    htop
    hypridle
    hyprland
    hyprlock
    hyprpanel
    hyprpicker
    hyprsunset
    igv
    inkscape
    jellyfin-media-player
    jq
    kdePackages.dolphin
    kdePackages.gwenview
    kitty
    libreoffice
    lm_sensors
    lsof
    lutris
    lxqt.lxqt-policykit
    mangohud
    mendeley
    mupdf
    nautilus
    nextflow
    nix-direnv
    nvchad
    obsidian
    openconnect
    openrazer-daemon
    openssl
    os-prober
    polychromatic
    power-profiles-daemon
    powertop
    prismlauncher
    python3
    rofi
    rustc
    socat
    starship
    superfile
    swappy
    syncthing
    swww
    temurin-bin-17
    tmux
    tree
    unzip
    virt-manager
    virtiofsd
    vlc
    vscode-fhs
    waypaper
    wl-clipboard
    wlogout
  ];
  nixpkgs.config.allowUnfree = true;
}

