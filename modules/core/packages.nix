{
  host,
  inputs,
  pkgs,
  ...
}: let
  inherit
    (import ../../hosts/${host}/variables.nix)
    hasRazer
    forGaming
    hostType
    ;
  myLutris = pkgs.lutris.override {
    extraPkgs = pkgs: [
      # e.g., pkgs.wineWowPackages.stable
      pkgs.proton-ge-bin
      pkgs.gamescope
      pkgs.gamemode
    ];
  };
in {
  programs = {
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    hyprland.enable = true;
  };

  fonts.packages = with pkgs; [
    #Fonts
    corefonts
    gelasio
    nerd-fonts.jetbrains-mono
    nerd-fonts.droid-sans-mono
    nerd-fonts.symbols-only
    roboto
    roboto-mono
    roboto-flex
    roboto-serif
  ];

  environment.systemPackages = with pkgs;
    [
      adwaita-icon-theme
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
      fiji
      fish
      gamescope
      ghostty
      gimp3
      git
      grim
      tuigreet
      grimblast
      gparted
      htop
      hyprpicker
      hyprsunset
      igv
      inkscape
      jellyfin-desktop
      jq
      kdePackages.dolphin
      kdePackages.gwenview
      kitty
      libreoffice
      lm_sensors
      lsof
      lxqt.lxqt-policykit
      mendeley
      mupdf
      nautilus
      nextflow
      nix-direnv
      nix-search-tv
      nix-prefetch-git
      nvidia_oc
      obsidian
      openconnect
      openssl
      os-prober
      plexamp
      plex-desktop
      power-profiles-daemon
      powertop
      python3
      qalculate-qt
      ripgrep
      rofi
      rustc
      rustdesk-flutter
      socat
      sshfs
      (pkgs.callPackage ../packages/snapgene.nix {})
      starship
      superfile
      swappy
      syncthing
      swww
      temurin-bin-17
      texliveFull
      #texmaker
      typst
      tree
      typst
      unzip
      virtiofsd
      vlc
      waypaper
      winboat
      wl-clipboard
      w3m
      xmlstarlet
      zoom-us
    ]
    ++ (
      if hasRazer
      then [polychromatic]
      else []
    )
    ++ (
      if forGaming
      then [mangohud prismlauncher gamemode mesa myLutris]
      else []
    )
    ++ (
      if hostType == "Desktop"
      then [coolercontrol.coolercontrol-gui heroic]
      else []
    );
  nixpkgs.config.allowUnfree = true;
}
