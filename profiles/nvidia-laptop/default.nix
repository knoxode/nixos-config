{
  host,
  lib,
  ...
}: {
  imports = [
    ../../hosts/${host}
    ../../modules/drivers
    ../../modules/core
    ../../specialisations/prime-offload.nix
  ];
  drivers.intel.enable = true;
  drivers.nvidia.enable = lib.mkForce false;
  # Optionally, if your driver module supports it
  boot.blacklistedKernelModules = ["nvidia" "nvidia_drm" "nvidia_uvm"];
}
