let
  #Setting hyprlock
  lock_cmd = "pidof hyprlock || hyprlock";
  suspend_cmd = "systemctl suspend ||  loginctl suspend";

  # Command to lower all DDC monitor brightness to 10 percent
  ddc_brightness_down = ''for bus in $(ddcutil detect 2>/dev/null | grep "I2C bus" | grep "/dev/i2c-" | grep -oE "[0-9]+$"); do ddcutil --bus=$bus setvcp 10 10 --sleep-multiplier=0.001; done'';

  # Command to restore all DDC monitor brightness to 100 percent
  ddc_brightness_up = ''for bus in $(ddcutil detect 2>/dev/null | grep "I2C bus" | grep "/dev/i2c-" | grep -oE "[0-9]+$"); do ddcutil --bus=$bus setvcp 10 100 --sleep-multiplier=0.001; done'';
in {
  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = lock_cmd;
          before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
          after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
          ignore_dbus_inhibit = false;
        };
        listener = [
          {
            timeout = 120; # 2min.
            on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0"; # turn off keyboard backlight.
            on-resume = "brightnessctl -rd rgb:kbd_backlight"; # turn on keyboard backlight.
          }
          {
            timeout = 120; # 2min.
            on-timeout = ''brightnessctl -s set 10''; # set monitor backlight to minimum, avoid 0 on OLED monitor.
            on-resume = ''brightnessctl -r''; # monitor backlight restore.
          }
          {
            timeout = 120; # 2min.
            on-timeout = ''${ddc_brightness_down}''; # set monitor backlight to minimum, avoid 0 on OLED monitor.
            on-resume = ''${ddc_brightness_up}''; # monitor backlight restore.
          }
          {
            timeout = 300; # 5min
            on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
          }
          {
            timeout = 1800; # 30min
            on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
            on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
          }
          {
            timeout = 3200; # 1hr
            on-timeout = suspend_cmd; # suspend pc
          }
        ];
      };
    };
  };
}
