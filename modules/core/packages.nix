{
  config,
  lib,
  pkgs,
  ...
}: {
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
      bash-language-server
      brightnessctl
      cifs-utils
      ddcutil
      direnv
      discord-canary
      easyeffects
      fastfetch
      (pkgs.callPackage ../packages/fiji.nix {})
      gh
      ghostty
      gimp3
      git
      grim
      tuigreet
      grimblast
      hyprpicker
      hyprsunset
      igv
      inkscape
      jellyfin-desktop
      jq
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
      os-prober
      powertop
      qalculate-qt
      ripgrep
      socat
      sshfs
      (pkgs.callPackage ../packages/snapgene.nix {})
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
    ++ lib.optionals config.alexos.host.razer [polychromatic]
    ++ lib.optionals config.alexos.host.gaming [
      mangohud
      # Default bundles jdk25+21+17+8 (~1.6 GiB); Minecraft downloads its
      # own JRE at runtime, so keep only one for the system Java setting.
      (prismlauncher.override {jdks = [jdk21];})
      gamemode
      mesa
    ]
    ++ lib.optionals (config.alexos.host.formFactor == "desktop") [
      coolercontrol.coolercontrol-gui
      heroic
    ]
    ++ lib.optionals config.alexos.host.nvidiaOc [nvidia_oc];
  nixpkgs.config.allowUnfree = true;
}
