{
  imports = [
    ./shaiikura.nix
  ];

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };
}
