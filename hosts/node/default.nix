{...}: {
  imports = [
    ./hardware.nix
  ];
  alexos.host = {
    formFactor = "desktop";
    gpu = "nvidia";
    gaming = true;
    razer = true;
    openrgb = true;
    coolercontrol = true;
    nvidiaOc = true;
    nvidiaContainerToolkit = true;
    suspendOnIdle = false;
    wifiPowersave = false;

    gpuDevices = {
      "nvidia-dgpu" = {
        vendor = "0x10de";
      };
    };

    hyprland = {
      latitude = 51.75;
      longitude = -1.25;
      keyboards = {
        us = [
          "razer-razer-huntsman-mini"
          "razer-razer-huntsman-mini-keyboard"
        ];
        gb = [];
      };
    };
  };
}
