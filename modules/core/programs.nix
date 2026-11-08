{...}: {
  programs = {
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
    };
  };
}
