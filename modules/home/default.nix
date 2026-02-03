{...}: {
  imports = [
    ./displayHotplugMonitor
    ./hyprland
    ./noctalia
    ./nvf
    ./tmux
    ./yazi
    ./zsh
    ./bash.nix
    ./btop.nix
    ./desktop_assets.nix
    ./fastfetch.nix
    ./grim.nix
    #./helix.nix
    #./hyprpanel.nix
    ./kitty.nix
    ./rofi.nix
    ./shellAliases.nix
    ./stylix.nix
    ./systemd.nix
    #./television.nix
    ./vscode.nix
    ./waypaper.nix
  ];
  xdg.userDirs.createDirectories = true;
}
