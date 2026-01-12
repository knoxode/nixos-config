{...}: {
  imports = [
    ./hyprland
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
    ./hyprpanel.nix
    ./kitty.nix
    ./rofi.nix
    ./stylix.nix
    #./television.nix
    ./vscode.nix
    ./waypaper.nix
    ./wlogout.nix
  ];
  xdg.userDirs.createDirectories = true;
}
