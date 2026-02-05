{...}: let
  # Sets the values for timers in seconds.
  shortestWait = 300;
  shortWait = 600;
  # medWait = 1800;
  longWait = 3200;

  ddcScriptPath = ".local/bin/ddc-set-brightness-safe.sh";
  #Setting noctalia lock screen
  lock_cmd = "noctalia-shell ipc call lockScreen lock";
  suspend_cmd = "systemctl suspend ||  loginctl suspend";
in {
  home.file."${ddcScriptPath}" = {
    source = ./ddcutilScripts/ddc-set-brightness-safe.sh;
    executable = true;
  };

  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          inherit lock_cmd;
          before_sleep_cmd = "loginctl lock-session"; # Lock before suspend.
          ignore_dbus_inhibit = false;
        };
        listener = [
          {
            timeout = shortestWait;
            on-timeout = "loginctl lock-session"; # Lock screen when timeout has passed
          }
          {
            timeout = shortWait;
            on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0"; # Turn off keyboard backlight.
            on-resume = "brightnessctl -rd rgb:kbd_backlight"; # Turn on keyboard backlight.
          }
          {
            timeout = shortWait;
            on-timeout = ''brightnessctl -s set 10''; # set monitor backlight to minimum value, avoid 0 on OLED monitor.
            on-resume = ''brightnessctl -r''; # Monitor backlight restore.
          }
          {
            timeout = shortWait;
            on-timeout = ''$HOME/${ddcScriptPath} down''; # set monitor backlight to minimum value, avoid 0 on OLED monitor.
            on-resume = ''${ddcScriptPath} up''; # Monitor backlight restore.
          }
          {
            timeout = longWait;
            on-timeout = suspend_cmd;
          }
        ];
      };
    };
  };
}
