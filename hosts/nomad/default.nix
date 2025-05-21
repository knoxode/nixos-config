{...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
    ./services/syncthing.nix
  ];
}
