{host, ...}: let
  inherit (import ../../hosts/${host}/variables.nix) gpuDevices;
  names = builtins.attrNames gpuDevices;
  gpuListStr = builtins.concatStringsSep ":" (
    map (n: "/dev/dri/${n}") names
  );
  preaqDrmDevices = "AQ_DRM_DEVICES," + gpuListStr;
in {
  imports = [
    ../../hosts/${host}
    ../../modules/drivers
    ../../modules/core
  ];
  # Enable GPU Drivers
  drivers = {
    amdgpu.enable = false;
    nvidia.enable = true;
    nvidia-prime.enable = false;
    intel.enable = false;
  };
  vm.guest-services.enable = false;
  hyprland.aqDrmDevices = preaqDrmDevices;
}
