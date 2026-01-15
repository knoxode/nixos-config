{host, ...}: let
  inherit (import ../hosts/${host}/variables.nix) intelID nvidiaID gpuDevices;
  names = builtins.attrNames gpuDevices;
  gpuListStr = builtins.concatStringsSep ":" (
    map (n: "/dev/dri/${n}") names
  );
  preaqDrmDevices = "AQ_DRM_DEVICES," + gpuListStr;
in {
  specialisation = {
    prime-offload.configuration = {
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
    };
  };
}
