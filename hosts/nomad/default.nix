{...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
  ];
  hyprOnMain = true;
}
