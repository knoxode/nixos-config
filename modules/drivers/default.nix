{config, ...}: {
  imports = [
    ./amd-drivers.nix
    ./intel-drivers.nix
    ./nvidia-drivers.nix
    ./nvidia-prime-drivers.nix
    ./vm-guest-services.nix
  ];

  drivers = {
    amdgpu.enable = config.alexos.host.gpu == "amd";
    intel.enable = config.alexos.host.gpu == "intel" || config.alexos.host.gpu == "nvidia-prime";
    nvidia.enable = config.alexos.host.gpu == "nvidia" || config.alexos.host.gpu == "nvidia-prime";
    nvidia-prime = {
      enable = config.alexos.host.gpu == "nvidia-prime";
      intelBusID = config.alexos.host.gpuBusIds.intel;
      nvidiaBusID = config.alexos.host.gpuBusIds.nvidia;
    };
  };

  vm.guest-services.enable = config.alexos.host.gpu == "vm";
}
