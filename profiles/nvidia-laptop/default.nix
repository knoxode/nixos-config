{host, ...}: let
  inherit (import ../../hosts/${host}/variables.nix) intelID nvidiaID gpuDevices;
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
    ../../specialisations/igpu_only.nix
  ];
  # Enable GPU Drivers
  drivers = {
    amdgpu.enable = false;
    intel.enable = true;
    nvidia-prime = {
      enable = true;
      intelBusID = "${intelID}";
      nvidiaBusID = "${nvidiaID}";
    };
  };
  hyprland.aqDrmDevices = preaqDrmDevices;
  vm.guest-services.enable = false;
}
