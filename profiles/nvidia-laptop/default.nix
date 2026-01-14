{
  host,
  lib,
  ...
}: let
  inherit (import ../../hosts/${host}/variables.nix) gpuDevices;
  names = builtins.attrNames gpuDevices;

  # Select only entries that declare vendor == "0x8086"
  intelNames =
    builtins.filter
    (n: builtins.hasAttr "vendor" gpuDevices.${n} && gpuDevices.${n}.vendor == "0x8086")
    names;
  # produce the colon-separated list, or null if empty
  intelOnlyDrmDevs = let
    items = map (n: "/dev/dri/${n}") intelNames;
  in
    if items == []
    then null
    else builtins.concatStringsSep ":" items;

  drmDevices = "AQ_DRM_DEVICES," + intelOnlyDrmDevs;
in {
  imports = [
    ../../hosts/${host}
    ../../modules/drivers
    ../../modules/core
    ../../specialisations/prime-offload.nix
  ];
  hyprland.aqDrmDevices = drmDevices;
  drivers.intel.enable = true;
  drivers.nvidia.enable = lib.mkForce false;
  # Optionally, if your driver module supports it
  boot.blacklistedKernelModules = ["nvidia" "nvidia_drm" "nvidia_uvm"];
}
