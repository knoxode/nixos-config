{ inputs, ... }:

{
  programs.hyprpanel = {
    enable = true;
    settings = {
      # --- Bar Settings ---
      bar.battery.hideLabelWhenFull = true;
      bar.bluetooth.label = false;
      bar.clock.format = "%a %b %d  %I:%M %p";
      bar.clock.scrollDown = "ddcutil --display=1 setvcp 10 0 && ddcutil --display=2 setvcp 10 0";
      bar.clock.scrollUp = "ddcutil --display=1 setvcp 10 100 && ddcutil --display=2 setvcp 10 100";
      bar.clock.showIcon = false;
      bar.clock.showTime = true;
      bar.customModules.cava.channels = 0;
      bar.customModules.cpuTemp.pollingInterval = 8000;
      bar.customModules.hypridle.pollingInterval = 2000;
      bar.customModules.hypridle.scrollDown = "";
      bar.customModules.hypridle.scrollUp = "";
      bar.customModules.hyprsunset.label = false;
      bar.customModules.hyprsunset.temperature = "4500k";
      bar.customModules.netstat.dynamicIcon = true;
      bar.customModules.netstat.label = true;
      bar.customModules.netstat.rateUnit = "MiB";
      bar.customModules.storage.paths = [ "/" ];
      bar.launcher.icon = "";
      bar.media.show_active_only = true;
      bar.network.label = false;
      bar.network.showWifiInfo = true;
      bar.volume.label = true;
      bar.volume.scrollDown = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-";
      bar.volume.scrollUp = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+";
      bar.windowtitle.custom_title = true;
      bar.workspaces.ignored = "^-\\d+$";
      bar.workspaces.numbered_active_indicator = "highlight";
      bar.workspaces.showWsIcons = false;
      bar.workspaces.show_numbered = true;
      bar.layouts = {
        "*" = {
          left = [ "dashboard" "workspaces" "media" ];
          middle = [ "clock" ];
          right = [ "systray" "hypridle" "hyprsunset" "volume" "network" "bluetooth" "battery" "notifications" ];
        };
      };

      # --- Menus Settings ---
      menus.bluetooth.showBattery = true;
      menus.clock.time.hideSeconds = true;
      menus.clock.time.military = true;
      menus.clock.weather.key = "1999bb6a16f5446db52112222241712";
      menus.clock.weather.location = "Oxford";
      menus.clock.weather.unit = "metric";
      menus.dashboard.powermenu.avatar.image = "/home/shaiikura/Documents/syncthing/asr/assets_for_desktop/hyprlock/GettyImages-1278848447-32a8c2139b6741b6978d0bfb97839dde.jpg";
      menus.dashboard.shortcuts.left.shortcut1.command = "firefox";
      menus.dashboard.shortcuts.left.shortcut1.icon = "󰈹";
      menus.dashboard.shortcuts.left.shortcut1.tooltip = "Firefox";
      menus.power.confirmation = true;
      menus.power.lowBatteryNotification = true;
      menus.power.showLabel = false;
      menus.transition = "crossfade";

      # --- Theme Settings ---
      theme.bar.border.width = "0.15em";
      theme.bar.buttons.background_opacity = 100;
      theme.bar.buttons.clock.enableBorder = false;
      theme.bar.buttons.dashboard.enableBorder = false;
      theme.bar.buttons.enableBorders = false;
      theme.bar.buttons.modules.hypridle.enableBorder = false;
      theme.bar.buttons.modules.netstat.enableBorder = false;
      theme.bar.buttons.opacity = 100;
      theme.bar.buttons.padding_x = "0.5rem";
      theme.bar.buttons.padding_y = "0.2rem";
      theme.bar.floating = false;
      theme.bar.menus.monochrome = false;
      theme.bar.opacity = 30;
      theme.bar.outer_spacing = "0.2em";
      theme.bar.transparent = false;
      theme.font.label = "JetBrainsMono Nerd Font";
      theme.font.name = "JetBrainsMono Nerd Font";
      theme.font.size = "1rem";
      theme.font.weight = 600;

      # --- Wallpaper Settings ---
      theme.matugen = false;
      wallpaper.enable = false;
      wallpaper.image = "/home/shaiikura/Documents/syncthing/asr/DesktopBackground/wallhaven-jx2q3w.jpg";
      wallpaper.pywal = false;

      # --- Notifications ---
      notifications.clearDelay = 60;
    };
  };
}

