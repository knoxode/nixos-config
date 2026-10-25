{
  host,
  pkgs,
  config,
  ...
}: let
  inherit (import ../../hosts/${host}/variables.nix) intelID nvidiaID;
in {
  imports = [
    ../../hosts/${host}
    ../../modules/drivers
    ../../modules/core
  ];
  drivers.intel.enable = true;
  # PRIME render offload: iGPU renders the session, dGPU runs on demand.
  drivers.nvidia-prime = {
    enable = true;
    intelBusID = intelID;
    nvidiaBusID = nvidiaID;
  };
  # Turing needs fine-grained runtime D3 explicitly: the driver default (0x03)
  # disables RTD3 on pre-Ampere GPUs. Lets the dGPU suspend when unused.
  hardware.nvidia.powerManagement.finegrained = true;
  # 615.78.08 + kernel 7.3: module probe runs in an nv-probe kthread whose
  # empty nullfs root breaks filp_open() on sysfs, so the driver reports
  # "Runtime D3 status: Not supported". CachyOS patch (kernel-patches
  # 89bb22d, kernel-patches#191) opens the config file from the userspace
  # root via scoped_with_init_fs(), restoring fine-grained RTD3. Applied
  # to the open kernel-module derivation (package.open), which is what
  # goes into boot.extraModulePackages. VERIFIED on nomad 2026-10-26:
  # "Runtime D3 status: Enabled (fine-grained)" and runtime_status
  # "suspended" at idle on the RTX 2060.
  hardware.nvidia.open = true;
  hardware.nvidia.package =
    let
      base = config.boot.kernelPackages.nvidiaPackages.new_feature;
      rtd3patch = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/CachyOS/kernel-patches/89bb22dec944d4d5b31332f2affbc740665cf0d9/7.3/misc/nvidia/0004-Open-sysfs-config-from-the-userspace-root-on-7.3.patch";
        hash = "sha256-pruuHakb6tcDDteKFh3t0tyNONSV74evJGc2Qu8dfKk=";
      };
    in
      base // {
        open = base.open.override { patches = base.open.patches ++ [ rtd3patch ]; };
      };
}
