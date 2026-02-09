{host, ...}: let
  inherit (import ./../../../hosts/${host}/variables.nix) hostType;
  ddcScriptPath = ".local/bin/ddc-set-brightness-safe.sh";
  #Setting noctalia lock screen
  lock_cmd = "noctalia-shell ipc call lockScreen lock";
  suspend_cmd = "systemctl suspend ||  loginctl suspend";
  before_sleep_cmd = "loginctl lock-session"; # Lock before suspend.
  ignore_dbus_inhibit = false;

  # Sets the values for timers in seconds.
  shortestWait = 300; # 5 minutes
  shortWait = 600; # 10 minutes
  # medWait = 1800; # 30 minutes
  longWait = 3200; # 60 minutes

  #Grouping Listeners by wait time
  shortestWaitListeners = [
    {
      timeout = shortestWait;
      on-timeout = "loginctl lock-session"; # Lock screen when timeout has passed
    }
  ];

  shortWaitListeners = [
    {
      timeout = shortWait;
      on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0"; # Turn off keyboard backlight.
      on-resume = "brightnessctl -l | grep -q rgb:kbd_backlight && brightnessctl -rd rgb:kbd_backlight"; # Turn on keyboard backlight. Now GUARDED if keyboard backlight doesn't exist
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
  ];

  longWaitListeners =
    if hostType != "Desktop"
    then [
      {
        timeout = longWait;
        on-timeout = suspend_cmd;
      }
    ]
    else [];
in {
  home.file."${ddcScriptPath}" = {
    source = ./ddcutilScripts/ddc-set-brightness-safe.sh;
    executable = true;
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {inherit lock_cmd before_sleep_cmd ignore_dbus_inhibit;};
      listener = shortestWaitListeners ++ shortWaitListeners ++ longWaitListeners;
    };
  };
}
