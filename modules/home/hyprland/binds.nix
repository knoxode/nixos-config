{host, ...}: let
  hostVars = import ../../../hosts/${host}/variables.nix;

  # Safe access with fallback
  hasDefinedMonitors = builtins.hasAttr "centerMonitor" hostVars && builtins.hasAttr "leftMonitor" hostVars;

  inherit
    (hostVars)
    browser
    terminal
    fileManager
    hostType
    ;

  preTerminalBind = "SUPER, return, exec, ${terminal}";
  terminalBind =
    if terminal == "kitty"
    then "${preTerminalBind} -e tmux new-session -A -s mainSesh"
    else "${preTerminalBind}";
  #Defines a set of keybinds mapping SUPER, x to the shell script with different numbers
  switchWorkspaceBinds =
    if hasDefinedMonitors
    then
      builtins.genList
      (
        i: let
          ws = toString (i + 1);
        in "SUPER,${ws},exec,~/.config/hypr/startupscripts/2_workspace.sh ${ws}"
      )
      5
    else [];

  moveWorkspaceBinds =
    builtins.genList
    (
      i: let
        key =
          if i == 9
          then "0"
          else toString (i + 1);
        ws = toString (i + 1);
      in "SUPER_SHIFT,${key},movetoworkspacesilent,${ws}"
    )
    10;
in {
  wayland.windowManager.hyprland.settings = {
    bind =
      [
        "SUPER, Q, killactive,"
        "SUPER, E, exec, ${fileManager}"
        "SUPER, R, exec, sleep 0.1 && noctalia-shell ipc call launcher toggle"
        "SUPER, W, exec, ${browser}"
        "${terminalBind}"
        "SUPER, h, movefocus, l"
        "SUPER, j, movefocus, d"
        "SUPER, k, movefocus, u"
        "SUPER, l, movefocus, r"
        "SUPER ALT, Space, togglefloating,"
        "SUPER, F, fullscreen, 0"
        "SUPER,T,exec,pypr toggle term"
        "$ALT,V,exec,pypr toggle spotify"
        "$ALT,B,exec,pypr toggle beeper"
        "$ALT,O,exec,pypr toggle obsidian"
        "$ALT,F,exec,pypr toggle discord"
        "SUPER+Shift, S, exec, grim -g \"$(slurp -d)\" - | wl-copy"
        "SUPER+Shift+Alt, S, exec, grim -g \"$(slurp)\" - | swappy -f - # Screen snip >> edit"
        "Ctrl+SUPER+Shift,S,exec,grim -g \"$(slurp $SLURP_ARGS)\" \"tmp.png\" && tesseract \"tmp.png\" - | wl-copy && rm \"tmp.png\" # [hidden]"
        "Ctrl+Alt, Delete, exec, noctalia-shell ipc call sessionMenu toggle"
      ]
      ++ switchWorkspaceBinds
      ++ moveWorkspaceBinds;

    bindel = [
      ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ",XF86MonBrightnessUp, exec, noctalia-shell ipc call brightness increase"
      ",XF86MonBrightnessDown, exec, noctalia-shell ipc call brightness decrease"
    ];

    bindl = [
      ",XF86AudioNext, exec, playerctl next"
      ",XF86AudioPause, exec, playerctl play-pause"
      ",XF86AudioPlay, exec, playerctl play-pause"
      ",Print,exec,grim - | wl-copy # Screenshot >> clipboard"
      "Ctrl,Print, exec, mkdir -p ~/Pictures/Screenshots && ~/.config/ags/scripts/grimblast.sh copysave screen ~/Pictures/Screenshots/Screenshot_\"\\$(date '+%Y-%m-%d_%H.%M.%S')\".png # Screenshot >> clipboard & file"
    ];

    bindm = [
      "SUPER, mouse:272, movewindow"
      "SUPER, mouse:273, resizewindow"
    ];
  };
}
