{ host, ... }:
let
  inherit
    (import ../../hosts/${host}/variables.nix)
    hostType
    ;

  barModules = if hostType == "Desktop" then {
    left = [ "dashboard" "workspaces" "media" ];
    middle = [ "clock" ];
    right = [ "systray" "hypridle" "hyprsunset" "volume" "network" "bluetooth" "notifications" ];
  } else {
    left = [ "dashboard" "workspaces" "media" ];
    middle = [ "clock" ];
    right = [ "systray" "hypridle" "hyprsunset" "volume" "network" "bluetooth" "battery" "notifications" ];
  };
in

{
  programs.hyprpanel = {
    enable = true;
    settings = {
      bar = {
        battery = {
          hideLabelWhenFull = true;
        };

        bluetooth = {
          label = false;
        };

        clock = {
          format = "%a %b %d  %I:%M %p";
          scrollDown = "ddcutil --display=1 setvcp 10 0 && ddcutil --display=2 setvcp 10 0";
          scrollUp = "ddcutil --display=1 setvcp 10 100 && ddcutil --display=2 setvcp 10 100";
          showIcon = false;
          showTime = true;
        };

        customModules = {
          cava.channels = 0;

          cpuTemp.pollingInterval = 8000;

          hypridle = {
            pollingInterval = 2000;
            scrollDown = "";
            scrollUp = "";
          };

          hyprsunset = {
            label = false;
            temperature = "4500k";
          };

          netstat = {
            dynamicIcon = true;
            label = true;
            rateUnit = "MiB";
          };

          storage.paths = [ "/" ];
        };

        launcher.icon = "";

        media.show_active_only = true;

        network = {
          label = false;
          showWifiInfo = true;
        };

        volume = {
          label = true;
          scrollDown = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-";
          scrollUp = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+";
        };

        windowtitle.custom_title = true;

        workspaces = {
          ignored = "^-\\d+$";
          numbered_active_indicator = "highlight";
          showWsIcons = false;
          show_numbered = true;
        };

        layouts."*" = {
          inherit (barModules) left middle right;
        };
      };

      menus = {
        bluetooth.showBattery = true;

        clock = {
          time = {
            hideSeconds = true;
            military = true;
          };
          weather = {
            key = "1999bb6a16f5446db52112222241712";
            location = "Oxford";
            unit = "metric";
          };
        };

        dashboard.powermenu.avatar.image = "/home/shaiikura/Documents/syncthing/asr/assets_for_desktop/hyprlock/GettyImages-1278848447-32a8c2139b6741b6978d0bfb97839dde.jpg";

        dashboard.shortcuts.left.shortcut1 = {
          command = "firefox";
          icon = "󰈹";
          tooltip = "Firefox";
        };

        power = {
          confirmation = true;
          lowBatteryNotification = true;
          showLabel = false;
        };

        transition = "crossfade";
      };

      theme = {
        bar = {
          border.width = "0.15em";
          buttons = {
            background_opacity = 100;
            clock.enableBorder = false;
            dashboard.enableBorder = false;
            enableBorders = false;
            modules = {
              hypridle.enableBorder = false;
              netstat.enableBorder = false;
            };
            opacity = 100;
            padding_x = "0.5rem";
            padding_y = "0.2rem";
          };
          floating = false;
          menus.monochrome = false;
          opacity = 30;
          outer_spacing = "0.2em";
          transparent = false;
        };

        font = {
          label = "JetBrainsMono Nerd Font";
          name = "JetBrainsMono Nerd Font";
          size = "1rem";
          weight = 600;
        };

        matugen = false;
      };

      wallpaper = {
        enable = false;
        image = "/home/shaiikura/Documents/syncthing/asr/DesktopBackground/wallhaven-jx2q3w.jpg";
        pywal = false;
      };

      notifications.clearDelay = 60;
    };
  };
}

