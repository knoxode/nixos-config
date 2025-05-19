{...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
    ./hypr/override.nix
  ];
}
