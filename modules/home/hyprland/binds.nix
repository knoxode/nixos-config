{ host, ... }:
let

  hostVars = import ../../../hosts/${host}/variables.nix;

  # Safe access with fallback
  hasDefinedMonitors = builtins.hasAttr "centerMonitor" hostVars && builtins.hasAttr "leftMonitor" hostVars;

  inherit (hostVars)
    browser
    terminal
    fileManager
    hostType
    ;

  #Defines a set of keybinds mapping $modifier, x to the shell script with different numbers
  workspaceScriptBinds =
    if hasDefinedMonitors then
      builtins.genList
        (i:
          let ws = toString (i + 1); in
          "$modifier,${ws},exec,~/.config/hypr/startupscripts/2_workspace.sh ${ws}"
        ) 5
    else
      [ ];

  safeBrightnessKeybind = if hostType == "Laptop" 
    then [ ",XF86MonBrightnessDown, exec, ~/.config/hypr/startupscripts/brightness-down-safe.sh" ] 
    else [ ",XF86MonBrightnessDown, exec, brightnessctl s 10%-" ]; 

in
{
  wayland.windowManager.hyprland.settings = {
    bind = [
      "$modifier, Q, killactive,"
      "$modifier, E, exec, ${fileManager}"
      "$modifier, R, exec, $menu"
      "$modifier, W, exec, ${browser}"
      # "$modifier,Y,exec,kitty -e yazi"
      "$modifier, return, exec, ${terminal}"
      "$modifier, left, movefocus, l"
      "$modifier, right, movefocus, r"
      "$modifier, up, movefocus, u"
      "$modifier, down, movefocus, d"
      "$modifier SHIFT, 1, movetoworkspacesilent, 1"
      "$modifier SHIFT, 2, movetoworkspacesilent, 2"
      "$modifier SHIFT, 3, movetoworkspacesilent, 3"
      "$modifier SHIFT, 4, movetoworkspacesilent, 4"
      "$modifier SHIFT, 5, movetoworkspacesilent, 5"
      "$modifier SHIFT, 6, movetoworkspacesilent, 6"
      "$modifier SHIFT, 7, movetoworkspacesilent, 7"
      "$modifier SHIFT, 8, movetoworkspacesilent, 8"
      "$modifier SHIFT, 9, movetoworkspacesilent, 9"
      "$modifier SHIFT, 0, movetoworkspacesilent, 10"
      "$modifier, mouse_down, workspace, e+1"
      "$modifier, mouse_up, workspace, e-1"
      "$modifier ALT, Space, togglefloating,"
      "$modifier, F, fullscreen, 0"
      "$modifier,T,exec,pypr toggle term"
      "$ALT,V,exec,pypr toggle spotify"
      "$ALT,B,exec,pypr toggle beeper"
      "$ALT,O,exec,pypr toggle obsidian"
      "$ALT,F,exec,pypr toggle discord"
      "$modifier+Shift, S, exec, grim -g \"$(slurp -d)\" - | wl-copy"
      "$modifier+Shift+Alt, S, exec, grim -g \"$(slurp)\" - | swappy -f - # Screen snip >> edit"
      "$modifier+Shift,T,exec,grim -g \"$(slurp $SLURP_ARGS)\" \"tmp.png\" && tesseract -l eng \"tmp.png\" - | wl-copy && rm \"tmp.png\" # Screen snip to text >> clipboard"
      "Ctrl+$modifier+Shift,S,exec,grim -g \"$(slurp $SLURP_ARGS)\" \"tmp.png\" && tesseract \"tmp.png\" - | wl-copy && rm \"tmp.png\" # [hidden]"
      "Ctrl+Alt, Delete, exec, pkill wlogout || wlogout -p layer-shell # [hidden]"
      # "ALT, X, togglespecialworkspace, outlook"
    ] ++ workspaceScriptBinds;

    bindel = [
      ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
    ] ++ safeBrightnessKeybind;

    bindl = [
      ",XF86AudioNext, exec, playerctl next"
      ",XF86AudioPause, exec, playerctl play-pause"
      ",XF86AudioPlay, exec, playerctl play-pause"
      ",Print,exec,grim - | wl-copy # Screenshot >> clipboard"
      "Ctrl,Print, exec, mkdir -p ~/Pictures/Screenshots && ~/.config/ags/scripts/grimblast.sh copysave screen ~/Pictures/Screenshots/Screenshot_\"\\$(date '+%Y-%m-%d_%H.%M.%S')\".png # Screenshot >> clipboard & file"
    ];

    bindm = [
      "$modifier, mouse:272, movewindow"
      "$modifier, mouse:273, resizewindow"
    ];
  };
}
