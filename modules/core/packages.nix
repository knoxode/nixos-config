{
  host,
  pkgs,
  ...
}: let
  inherit
    (import ../../hosts/${host}/variables.nix)
    hasRazer
    forGaming
    hostType
    ;
in {
  programs = {
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
    };
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
      brightnessctl
      cifs-utils
      ddcui
      ddcutil
      direnv
      discord-canary
      easyeffects
      fastfetch
      (pkgs.callPackage ../packages/fiji.nix {})
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
      libreoffice
      lm_sensors
      lsof
      lxqt.lxqt-policykit
      mupdf
      nautilus
      nix-direnv
      nix-search-tv
      nix-prefetch-git
      obsidian
      openconnect
      os-prober
      plexamp
      powertop
      qalculate-qt
      ripgrep
      rustdesk-flutter
      socat
      sshfs
      (pkgs.callPackage ../packages/snapgene.nix { })
      swappy
      syncthing
      typst
      tree
      unzip
      vlc
      winboat
      wl-clipboard
      zoom-us
    ]
    ++ (
      if hasRazer
      then [polychromatic]
      else []
    )
    ++ (
      if forGaming
      then [
        mangohud
        # Default bundles jdk25+21+17+8 (~1.6 GiB); Minecraft downloads its
        # own JRE at runtime, so keep only one for the system Java setting.
        (prismlauncher.override { jdks = [jdk21]; })
        gamemode
        mesa
      ]
      else []
    )
    ++ (
      if hostType == "Desktop"
      then [coolercontrol.coolercontrol-gui heroic nvidia_oc]
      else []
    );
  nixpkgs.config.allowUnfree = true;
}
