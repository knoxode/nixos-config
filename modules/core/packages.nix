{
  host,
  pkgs,
  ...
}: let
  inherit
    (import ../../hosts/${host}/variables.nix)
    hasRazer
    forGaming
    ;
in {
  programs = {
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    firefox.enable = true;
    fish.enable = true;
    hyprland.enable = true;
    starship.enable = true;
  };

  fonts.packages = with pkgs; [
    #Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.droid-sans-mono
    nerd-fonts.symbols-only
  ];

  environment.systemPackages = with pkgs;
    [
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
      gimp
      git
      grim
      greetd.tuigreet
      grimblast
      gparted
      htop
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
      mendeley
      mupdf
      nautilus
      nextflow
      nix-direnv
      # nvchad
      obsidian
      openconnect
      openssl
      os-prober
      power-profiles-daemon
      powertop
      python3
      rofi
      rustc
      socat
      (pkgs.callPackage ../packages/snapgene.nix {})
      starship
      superfile
      swappy
      syncthing
      swww
      temurin-bin-17
      tmux
      tree
      unzip
      virtiofsd
      vlc
      vscode-fhs
      waypaper
      wl-clipboard
      wlogout
      w3m
    ]
    ++ (
      if hasRazer
      then [polychromatic]
      else []
    )
    ++ (
      if forGaming
      then [mangohud prismlauncher gamemode]
      else []
    );
  nixpkgs.config.allowUnfree = true;
}
