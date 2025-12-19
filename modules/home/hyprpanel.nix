{host, ...}: let
  inherit
    (import ../../hosts/${host}/variables.nix)
    hostType
    ;

  barModules =
    if hostType == "Desktop"
    then {
      left = ["dashboard" "workspaces" "media"];
      middle = ["clock"];
      right = ["systray" "hypridle" "hyprsunset" "volume" "network" "bluetooth" "notifications"];
    }
    else {
      left = ["dashboard" "workspaces" "media"];
      middle = ["clock"];
      right = ["systray" "hypridle" "hyprsunset" "volume" "network" "bluetooth" "battery" "notifications"];
    };

  clockScroll =
    if host == "node"
    then {
      scrollDown = "ddcutil --bus=8 --sleep-multiplier=0.001 setvcp 10 10 && ddcutil --bus=9 --sleep-multiplier=0.001 setvcp 10 10";
      scrollUp = "ddcutil --bus=8 --sleep-multiplier=0.001 setvcp 10 100 && ddcutil --bus=9 --sleep-multiplier=0.001 setvcp 10 100";
    }
    else if host == "reuby"
    then {
      scrollDown = "ddcutil --display=1 --sleep-multiplier=0.001 setvcp 10 0 && brightnessctl set 10%";
      scrollUp = "ddcutil --display=1 --sleep-multiplier=0.001 setvcp 10 100 && brightnessctl set 100%";
    }
    else if host == "nomad"
    then {
      scrollDown = "ddcutil --display=1 --sleep-multiplier=0.001 setvcp 10 0 && brightnessctl set 10%";
      scrollUp = "ddcutil --display=1 --sleep-multiplier=0.001 setvcp 10 100 && brightnessctl set 100%";
    }
    else {
      scrollDown = "ddcutil --display=1 --sleep-multiplier=0.001 setvcp 10 0 && ddcutil --display=2 --sleep-multiplier=0.001 setvcp 10 0";
      scrollUp = "ddcutil --display=1 --sleep-multiplier=0.001 setvcp 10 100 && ddcutil --display=2 --sleep-multiplier=0.001 setvcp 10 100";
    };
in {
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
          inherit (clockScroll) scrollDown scrollUp;
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

          storage.paths = ["/"];
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
            location = "auto";
            unit = "metric";
          };
        };

        dashboard.powermenu.avatar.image = "~/.config/hypr/hyprlockassets/GettyImages-1278848447-32a8c2139b6741b6978d0bfb97839dde.jpg";

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
        image = "~/Documents/syncthing/asr/DesktopBackground/wallhaven-jx2q3w.jpg";
        pywal = false;
      };

      notifications.clearDelay = 60;
    };
  };
}
