{lib, ...}: {
  options.hyprland.aqDrmDevices = lib.mkOption {
    type = lib.types.str;
    default = null;
  };
}
