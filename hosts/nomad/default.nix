{...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
  ];
  hyprOnMain = false;
}
