{host, ...}: let
  inherit (import ../hosts/${host}/variables.nix) intelID nvidiaID;
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
    };
  };
}
