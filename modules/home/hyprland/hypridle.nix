{host, ...}: let
  inherit
    (import ../../../hosts/${host}/variables.nix)
    hostType
    ;
  ddcScriptPath = ".local/bin/ddc-set-brightness-safe.sh";
  #Setting noctalia lock screen
  lock_cmd = "noctalia-shell ipc call lockScreen lock";
  suspend_cmd = "systemctl suspend ||  loginctl suspend";

  # Command to lower all DDC monitor brightness to 10 percent
  dpmsOn = ''sleep 2 && hyprctl dispatch dpms on'';
  dpmsOff = ''sleep 2 && hyprctl dispatch dpms off'';

  laptopSuspendListener =
    if hostType == "Laptop"
    then [
      {
        timeout = 3200;
        on-timeout = suspend_cmd;
      }
    ]
    else [];
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
          after_sleep_cmd = dpmsOn; # To avoid having to press a key twice to turn on the display.
          on_unlock_cmd = "hyprctl reload";
          ignore_dbus_inhibit = false;
        };
        listener =
          [
            {
              timeout = 300; # 5 minutes
              on-timeout = "loginctl lock-session"; # Lock screen when timeout has passed
            }
            {
              timeout = 600; # 2 minutes.
              on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0"; # Turn off keyboard backlight.
              on-resume = "brightnessctl -rd rgb:kbd_backlight"; # Turn on keyboard backlight.
            }
            {
              timeout = 600; # 2 minutes.
              on-timeout = ''brightnessctl -s set 10''; # set monitor backlight to minimum value, avoid 0 on OLED monitor.
              on-resume = ''brightnessctl -r''; # Monitor backlight restore.
            }
            {
              timeout = 600; # 2 minutes.
              on-timeout = ''$HOME/${ddcScriptPath} down''; # set monitor backlight to minimum value, avoid 0 on OLED monitor.
              on-resume = ''${ddcScriptPath} up''; # Monitor backlight restore.
            }
            {
              timeout = 1800; # 30 minutes
              on-timeout = dpmsOff; # Screen off when timeout has passed
              on-resume = dpmsOn; # Screen on when activity is detected after timeout has fired.
            }
          ]
          ++ laptopSuspendListener;
      };
    };
  };
}
