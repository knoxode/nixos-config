{
  # Set modifiers
  mainMod = "super";
  terminal = "kitty";
  fileManager = "nautilus";
  menu = "rofi -show drun";

  bind = [
    # Program binds
    "$mainMod, Q, killactive"
    "$mainMod, E, exec, $fileManager"
    "$mainMod, R, exec, $menu"
    "$mainMod, w, exec, firefox"
    "$mainMod, return, exec, $terminal"

    # Move focus with arrow keys
    "$mainMod, left, movefocus, l"
    "$mainMod, right, movefocus, r"
    "$mainMod, up, movefocus, u"
    "$mainMod, down, movefocus, d"

    # Switch to specific workspaces
    "$mainMod, 1, exec, ~/.config/hypr/2_workspace.sh 1"
    "$mainMod, 2, exec, ~/.config/hypr/2_workspace.sh 2"
    "$mainMod, 3, exec, ~/.config/hypr/2_workspace.sh 3"
    "$mainMod, 4, exec, ~/.config/hypr/2_workspace.sh 4"
    "$mainMod, 5, exec, ~/.config/hypr/2_workspace.sh 5"

    # Move active window to workspace
    "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
    "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
    "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
    "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
    "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
    "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
    "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
    "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
    "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
    "$mainMod SHIFT, 0, movetoworkspacesilent, 10"

    # Special workspace (scratchpad)
    "$mainMod, S, togglespecialworkspace, spotify"

    # Scroll through workspaces
    "$mainMod, mouse_down, workspace, e+1"
    "$mainMod, mouse_up, workspace, e-1"

    # Move/resize windows with mouse
    "$mainMod, mouse:272, movewindow"
    "$mainMod, mouse:273, resizewindow"

    # Multimedia keys for volume/brightness
    ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
    ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
    ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"

    # Playerctl controls
    ",XF86AudioNext, exec, playerctl next"
    ",XF86AudioPause, exec, playerctl play-pause"
    ",XF86AudioPlay, exec, playerctl play-pause"
    ",XF86AudioPrev, exec, playerctl previous"

    # Positioning mode
    "$mainMod+Alt, Space, togglefloating"
    "$mainMod+Alt, F, fullscreenstate, 0 3" # Toggle fake fullscreen
    "$mainMod, F, fullscreen, 0"
    "$mainMod, D, fullscreen, 1"

    # Screenshot binds
    "$mainMod+Shift, S, exec, grim -g \"$(slurp -d)\" - | wl-copy"
    "$mainMod+Shift+Alt, S, exec, grim -g \"$(slurp)\" - | swappy -f -"
    "$mainMod+Shift,T,exec,grim -g \"$(slurp $SLURP_ARGS)\" \"tmp.png\" && tesseract -l eng \"tmp.png\" - | wl-copy && rm \"tmp.png\""
    "Ctrl+$mainMod+Shift,S,exec,grim -g \"$(slurp $SLURP_ARGS)\" \"tmp.png\" && tesseract \"tmp.png\" - | wl-copy && rm \"tmp.png\""
    ",Print,exec,grim - | wl-copy"
    "Ctrl,Print, exec, mkdir -p ~/Pictures/Screenshots && ~/.config/ags/scripts/grimblast.sh copysave screen ~/Pictures/Screenshots/Screenshot_\"$(date '+%Y-%m-%d_%H.%M.%S')\".png"

    # Lock screen bind
    "Ctrl+Alt, Delete, exec, pkill wlogout || wlogout -p layer-shell"
  ];
}


