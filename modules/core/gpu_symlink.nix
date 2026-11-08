{
  config,
  lib,
  ...
}: let
  inherit (config.alexos.host) gpuDevices;

  gpuRules = builtins.concatStringsSep "\n" (
    lib.mapAttrsToList (name: attrs: ''
      KERNEL=="card*", \
      SUBSYSTEM=="drm", \
      SUBSYSTEMS=="pci", \
      ATTRS{vendor}=="${attrs.vendor}", \
      SYMLINK+="dri/${name}"
    '')
    gpuDevices
  );
in {
  services.udev.extraRules = gpuRules;
}
