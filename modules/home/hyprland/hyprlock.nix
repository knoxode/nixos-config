{
  osConfig,
  config,
  ...
}: let
  inherit (osConfig.users.users.${config.home.username}) description firstname;
  # path = "~/Documents/syncthing/asr/assets_for_desktop/profilePictures/IMG_1300.png";
  avatarImageExt =
    if config.home.username == "shaiikura"
    then "jpg"
    else "png";

  avatar.image = "~/.profilePic.${avatarImageExt}";
in {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = false;
      };
      background = [
        {
          monitor = "";
          path = "~/.cache/.wallpaper";
          color = "rgba(25, 20, 20, 1.0)";

          # all these options are taken from hyprland, see https://wiki.hyprland.org/Configuring/Variables/#blur for explanations
          blur_passes = 1; # 0 disables blurring
          blur_size = 2;
          noise = 0.0117;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.30;
          vibrancy_darkness = 1;
          reload_time = 60;
        }
      ];
      image = [
        {
          #Eddie van halen profile circle
          monitor = "";
          path = avatar.image;
          border_color = "0xffdddddd";
          border_size = 0;
          size = 125;
          rounding = -1;
          rotate = 0;
          reload_time = -1;
          position = "0%, 19.44%";
          halign = "center";
          valign = "bottom";
        }
        {
          #BOTTOM CENTER
          #NIXOS ICON
          monitor = "";
          path = "~/.config/hypr/hyprlockassets/nix-snowflake-colours.png";
          size = 70;
          position = "0%, 2.77%";
          border_size = 0;
          rounding = 0;
          halign = "center";
          valign = "bottom";
        }
      ];
      input-field = [
        {
          monitor = "";
          size = "200, 50";
          outline_thickness = 3;
          dots_size = 0.33; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = false;
          dots_rounding = -1; # -1 default circle, -2 follow input-field rounding
          outer_color = "rgb(151515)";
          inner_color = "rgb(200, 200, 200)";
          font_color = "rgb(10, 10, 10)";
          font_family = "JetBrains Mono Nerd Font";
          fade_on_empty = false;
          fade_timeout = 1000; # Milliseconds before fade_on_empty is triggered.
          placeholder_text = "<i>Type Your Password...</i>"; # Text rendered in the input box when it's empty.
          hide_input = false;
          rounding = -1; # -1 means complete rounding (circle/oval)
          check_color = "rgb(204, 136, 34)";
          fail_color = "rgb(204, 34, 34)"; # if authentication failed, changes outer_color and fail message color
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>"; # can be set to empty
          capslock_color = -1;
          numlock_color = -1;
          bothlock_color = -1; # when both locks are active. -1 means don't change outer color (same for above)
          invert_numlock = false; # change color if numlock is off

          position = "0%, 11.1%";
          halign = "center";
          valign = "bottom";
        }
      ];
      label = [
        {
          monitor = "";
          text = "Hi there, ${firstname}!";
          color = "rgba(200, 200, 200, 1.0)";
          font_size = 24;
          font_family = "JetBrains Mono Nerd Font";
          position = "0%, 19.4%";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = ''
            cmd[update:1000] echo "<b><big> $(date +"%A"), $(date +"%d %b %Y") </big></b>"
          '';
          color = "rgba(255,255,255,1)";
          font_size = 24;
          font_family = "JetBrains Mono Nerd Font";
          position = "0%, 37.03%";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = ''
            cmd[update:1000] echo "<b><big><span color='white'>$(date +'%H')</span>:<span color='gray'>$(date +'%M')</span></big></b>"
          '';
          color = "rgba(255,255,255,1)";
          font_size = 128;
          font_family = "JetBrains Mono Nerd Font";
          position = "0%, 27.77%";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = ''
            cmd[update:1000] echo "<b><big> ${description} </big></b>"
          '';
          color = "rgba(255,255,255,1)";
          font_size = 12;
          font_family = "JetBrains Mono Nerd Font";
          position = "0%, 16.66%";
          halign = "center";
          valign = "bottom";
        }
        {
          # Location & Weather
          monitor = "";
          text = ''
            cmd[update:1800000] ~/.config/hypr/scripts/weather_location.sh
          '';
          color = "rgba(255, 255, 255, 1)";
          font_size = 12;
          font_family = "JetBrains Mono Nerd Font";
          position = "1.5625%,-2.77%";
          halign = "left";
          valign = "top";
        }
        {
          #Playertitle
          monitor = "";
          text = ''
            cmd[update:60000] echo "$(~/.config/hypr/scripts/playerctlock.sh --title)"
          '';
          color = "rgba(255, 255, 255, 0.8)";
          font_size = 12;
          font_family = "JetBrains Mono Nerd Font";
          position = "0%, -2.77%";
          halign = "center";
          valign = "top";
        }
        {
          monitor = "";
          text = ''
            cmd[update:1000] echo "$(~/.config/hypr/scripts/playerctlock.sh --artist)"
          '';
          color = "rgba(255, 255, 255, 0.8)";
          font_size = 10;
          font_family = "JetBrains Mono Nerd Font";
          position = "0%,-5.54%";
          halign = "center";
          valign = "top";
        }
        {
          monitor = "";
          text = ''
            cmd[update:60000] echo "$(~/.config/hypr/scripts/news.sh)"
          '';
          color = "rgba(255, 255, 255, 0.8)";
          font_size = 16;
          font_family = "JetBrains Mono Nerd Font Bold";
          position = "1.5625%,2.77%";
          halign = "left";
          valign = "bottom";
        }
        {
          #TOP RIGHT
          #WIFI STATUS
          monitor = "";
          text = ''
            cmd[update:1000] echo "$(~/.config/hypr/scripts/wifi-status.sh)"
          '';
          color = "rgba(242, 243, 244, 0.75)";
          font_size = 16;
          font_family = "Symbols Nerd Font";
          position = "-1.5625%, -2.77%";
          halign = "right";
          valign = "top";
        }
        {
          # TOP RIGHT
          # BATTERY STATUS
          monitor = "";
          text = ''
            cmd[update:1000] echo "$(~/.config/hypr/scripts/battery-status.sh)"
          '';
          color = "rgba(242, 243, 244, 0.75)";
          font_size = 16;
          font_family = "Symbols Nerd Font";
          position = "-3.125%, -2.77%";
          halign = "right";
          valign = "top";
        }
        {
          #BOTTOM RIGHT
          #HIBERNATE THEN SUSPEND BUTTON
          monitor = "";
          text = "⏾";
          onclick = "systemctl suspend-then-hibernate";
          color = "rgba(242, 243, 244, 0.75)";
          font_size = 16;
          font_family = "Symbols Nerd Font";
          position = "-1.5625%, 2.77%";
          halign = "right";
          valign = "bottom";
        }
        {
          #BOTTOM RIGHT
          #HIBERNATE BUTTON
          monitor = "";
          text = "󰒲";
          onclick = "systemctl hibernate";
          color = "rgba(242, 243, 244, 0.75)";
          font_size = 16;
          font_family = "Symbols Nerd Font";
          position = "-3.125%, 2.77%";
          halign = "right";
          valign = "bottom";
        }
      ];
    };
  };
}
#################
#   TOP LEFT    #
#################
# #MUSIC
# image {
#     monitor = "";
#     path =
#     size = 60 # lesser side if not 1:1 ratio
#     rounding = 5 # negative values mean circle
#     border_size = 0
#     rotate = 0 # degrees, counter-clockwise
#     reload_time = 2
#     reload_cmd = ~/.config/hypr/scripts/playerctlock.sh --arturl
#     position = 0,0
#     halign = "left";
#     valign = "top";
#     opacity=0.5
# }
# # PLAYER Length
# label {
#     monitor = "";
# #    text= cmd[update:1000] echo "$(( $(playerctl metadata --format "{{ mpris:length }}" 2>/dev/null) / 60000000 ))m"
#     text = cmd[update:1000] echo "$(~/.config/hypr/scripts/playerctlock.sh --length) "
#     color = rgba(255, 255, 255, 1)
#     font_size = 11
#     font_family = JetBrains Mono Nerd Font
#     position = 0,0
#     halign = "left";
#     valign = "top";
# }
#
# # PLAYER STATUS
# label {
#     monitor = "";
# #    text= cmd[update:1000] echo "$(( $(playerctl metadata --format "{{ mpris:length }}" 2>/dev/null) / 60000000 ))m"
#     text = cmd[update:1000] echo "$(~/.config/hypr/scripts/playerctlock.sh --status)"
#     color = rgba(255, 255, 255, 1)
#     font_size = 14
#     font_family = JetBrains Mono Nerd Font
#     position = 0,0
#     halign = right
#     valign = "center"
# }
# # PLAYER SOURCE
#
# label {
#     monitor = "";
# #    text= cmd[update:1000] echo "$(playerctl metadata --format "{{ mpris:trackid }}" 2>/dev/null | grep -Eo "chromium|firefox|spotify")"
#     text = cmd[update:1000] echo "$(~/.config/hypr/scripts/playerctlock.sh --source)"
#     color = rgba(255, 255, 255, 0.6)
#     font_size = 10
#     font_family = JetBrains Mono Nerd Font
#     position = 0,0
#     halign = "left";
#     valign = "top";
# }
#
# # PLAYER ALBUM
# label {
#     monitor = "";
#     text = cmd[update:1000] echo "$(~/.config/hypr/scripts/playerctlock.sh --album)"
#     color = rgba(255, 255, 255, 1)
#     font_size = 10
#     font_family = JetBrains Mono Nerd Font
#     position = 0,0
#     halign = "left";
#     valign = "top";
# }
#
# # PLAYER Artist
# label {
#     monitor = "";
# #    text = cmd[update:1000] echo "$(playerctl metadata --format "{{ xesam:artist }}" 2>/dev/null | cut -c1-30)"
#     text = cmd[update:1000] echo "$(~/.config/hypr/scripts/playerctlock.sh --artist)"
#     color = rgba(255, 255, 255, 0.8)
#     font_size = 10
#     font_family = JetBrains Mono Nerd Font Mono ExtraBold
#     position = 0,0
#     halign = "left";
#     valign = "top";
# }
##############
# ANIMATIONS #
##############
# Styles will eventually be added, but not ready yet.
# animation =

