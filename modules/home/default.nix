{...}: {
  imports = [
    ./displayHotplugMonitor
    ./hyprland
    ./noctalia
    ./nvf
    ./opencode
    ./tmux
    ./yazi
    ./zsh
    ./bash.nix
    ./btop.nix
    ./defaultApps.nix
    ./desktop_assets.nix
    ./fastfetch.nix
    ./ghostty.nix
    ./grim.nix
    ./harperSharedLib.nix
    ./shellAliases.nix
    ./stylix.nix
    ./systemd.nix
  ];

  # NixOS defaults EDITOR to nano. Override per user so sops (and other
  # EDITOR users) open the configured editor instead.
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  xdg.userDirs.createDirectories = true;
}
