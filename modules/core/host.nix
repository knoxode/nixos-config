{lib, ...}: {
  options.alexos.host = {
    formFactor = lib.mkOption {
      type = lib.types.enum ["desktop" "laptop"];
      default = "laptop";
      description = "Host form factor; drives power and peripheral defaults.";
    };

    gpu = lib.mkOption {
      type = lib.types.enum ["intel" "amd" "nvidia" "nvidia-prime" "vm"];
      default = "intel";
      description = "Primary GPU stack. The profile still selects the driver modules.";
    };

    gaming = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Install the gaming stack (Steam, GameMode, MangoHud, ...).";
    };

    razer = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Razer peripheral support (OpenRazer, Polychromatic).";
    };

    openrgb = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Run OpenRGB. Kept off on laptops to preserve package C-states.";
    };

    coolercontrol = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Run coolercontrol. Desktop-only: its NVML handle blocks RTD3.";
    };

    nvidiaOc = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Run the nvidia_oc overclocking service.";
    };

    nvidiaContainerToolkit = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the NVIDIA container toolkit.";
    };

    hotplugMonitor = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Run the display hotplug monitor user service.";
    };

    suspendOnIdle = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Suspend the session on idle.";
    };

    wifiPowersave = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Let NetworkManager enable Wi-Fi powersave (battery over latency).";
    };

    printing = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable CUPS and ipp-usb.";
    };

    autoUpdate = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Apply CI-validated origin/main updates automatically.";
    };

    gpuDevices = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options.vendor = lib.mkOption {
          type = lib.types.str;
          description = "PCI vendor ID, for example 0x10de.";
        };
      });
      default = {};
      description = "GPU devices mapped to stable /dev/dri symlink names.";
    };

    gpuBusIds = lib.mkOption {
      type = lib.types.submodule {
        options = {
          intel = lib.mkOption {
            type = lib.types.str;
            default = "PCI:0:2:0";
          };
          nvidia = lib.mkOption {
            type = lib.types.str;
            default = "PCI:1:0:0";
          };
        };
      };
      default = {};
      description = "PCI bus IDs for NVIDIA PRIME offload.";
    };

    hyprland = lib.mkOption {
      type = lib.types.submodule {
        options = {
          latitude = lib.mkOption {
            type = lib.types.float;
            default = 0.0;
          };
          longitude = lib.mkOption {
            type = lib.types.float;
            default = 0.0;
          };
          keyboards = lib.mkOption {
            type = lib.types.attrsOf (lib.types.listOf lib.types.str);
            default = {};
          };
        };
      };
      default = {};
      description = "Host data used to generate Hyprland's host.lua and devices.lua.";
    };
  };
}
