{...}: {
  imports = [
    ./hardware.nix
  ];

  alexos.host.gpu = "nvidia";
}
