{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.alexos.host.nvidiaContainerToolkit {
    hardware.nvidia-container-toolkit = {
      enable = true;
    };
  };
}
