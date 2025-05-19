{ host, ... }:
  imports = [
    ../../hosts/${host}
    ../../modules/drivers
    ../../modules/core
  ];
}
