{inputs, ...}: {
  imports = [
    inputs.noctalia.nixosModules.default
  ];
  services.noctalia-shell = {
    enable = true;
    target = "hyprland-session.target";
  };
}
