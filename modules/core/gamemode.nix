{ pkgs, ... }:

{
  programs.gamemode.enable = true;

  programs.gamemode.settings = {
    general = {
      renice = 10;
    };

    # Warning: GPU optimisations have the potential to damage hardware
    gpu = {
      apply_gpu_optimisations = "accept-responsibility";
      gpu_device = 0;
      nv_powermizer_mode = 1;
    };

    custom = {
      start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
      end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
    };
  };
}
