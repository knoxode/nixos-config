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
    #./helix.nix
    ./kitty.nix
    ./shellAliases.nix
    ./stylix.nix
    ./systemd.nix
    #./television.nix
    ./vscode.nix
    ./waypaper.nix
  ];
  xdg.userDirs.createDirectories = true;
}
