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
  xdg.userDirs.createDirectories = true;
}
