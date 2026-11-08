{...}: {
  imports = [
    ./hardware.nix
  ];

  alexos.host.gpu = "intel";
}
