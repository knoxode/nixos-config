{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.drivers.nvidia;
in {
  options.drivers.nvidia = {
    enable = mkEnableOption "Enable Nvidia Drivers";
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      # mkDefault: hosts with specific GPU needs (e.g. nomad's patched 615)
      # override this in their profile.
      package = mkDefault config.boot.kernelPackages.nvidiaPackages.production;
      modesetting.enable = true;

      powerManagement.enable = true;

      # mkDefault: Turing laptops set false — the open+GSP kernel modules
      # break runtime D3 (RTD3) on Turing cards.
      open = mkDefault true;
    };
  };
}
