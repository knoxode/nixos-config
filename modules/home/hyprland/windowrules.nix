{host, ...}: let
  inherit
    (import ../../../hosts/${host}/variables.nix)
    extraMonitorSettings
    ;
in {
  wayland.windowManager.hyprland = {
    settings = {
      windowrulev2 = [
        "tag +file-manager, class:^([Tt]hunar|org.gnome.Nautilus|[Pp]cmanfm-qt)$"
        "tag +terminal, class:^(com.mitchellh.ghostty|org.wezfurlong.wezterm|Alacritty|kitty|kitty-dropterm)$"
        "tag +browser, class:^(Brave-browser(-beta|-dev|-unstable)?)$"
        "tag +browser, class:^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr)$"
        "tag +browser, class:^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$"
        "tag +browser, class:^([Tt]horium-browser|[Cc]achy-browser)$"
        "tag +projects, class:^(codium|codium-url-handler|VSCodium)$"
        "tag +projects, class:^(VSCode|code-url-handler)$"
        "tag +im, class:^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$"
        "tag +im, class:^([Ff]erdium)$"
        "tag +im, class:^([Ww]hatsapp-for-linux)$"
        "tag +im, class:^(org.telegram.desktop|io.github.tdesktop_x64.TDesktop)$"
        "tag +im, class:^(teams-for-linux)$"
        "tag +games, class:^(gamescope)$"
        "tag +games, class:^(steam_app_\\d+)$"
        "tag +gamestore, class:^([Ss]team)$"
        "tag +gamestore, title:^([Ll]utris)$"
        "tag +gamestore, class:^(com.heroicgameslauncher.hgl)$"
        "tag +settings, class:^(gnome-disks|wihotspot(-gui)?)$"
        # "tag +settings, class:^([Rr]ofi)$"
        "tag +settings, class:^(file-roller|org.gnome.FileRoller)$"
        "tag +settings, class:^(nm-applet|nm-connection-editor|blueman-manager)$"
        "tag +settings, class:^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$"
        "tag +settings, class:^(nwg-look|qt5ct|qt6ct|[Yy]ad)$"
        "tag +settings, class:^xdg-desktop-portal-gtk$"
        "tag +settings, class:^\\.blueman-manager-wrapped$"
        "tag +settings, class:^nwg-displays$"

        "move 72% 7%, title:^Picture-in-Picture$"

        "center, class:^([Ff]erdium)$"
        "float, class:^(io.github.Qalculate.qalculate-qt)$"
        "float, class:^([Ww]aypaper)$"
        "center, class:^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$"

        # Thunar: match class exactly, and ensure title doesn't contain Thunar (explicit substring)
        "center, class:^([Tt]hunar)$, title:negative:^.*[Tt]hunar.*$"

        "center, class:^BeeperTexts$"
        "center, title:^Authentication Required$"

        # Normalize parentheses/capture groups to simpler anchored substrings
        "center, title:^Open File.*$"
        "center, title:^Select a File.*$"
        "center, title:^Choose wallpaper.*$"
        "center, title:^Open Folder.*$"
        "center, title:^Save As.*$"
        "center, title:^Library.*$"

        # Apply idleinhibit to all classes/titles (was class:^(*)$ / title:^(*)$)
        "idleinhibit fullscreen, class:^.*$"
        "idleinhibit fullscreen, title:^.*$"
        "idleinhibit fullscreen, fullscreen:1"

        "float, tag:settings*"
        "float, class:^BeeperTexts$"
        "float, class:^([Ff]erdium)$"
        "float, title:^Picture-in-Picture$"
        "float, class:^(mpv|com.github.rafostar.Clapper)$"
        "float, title:^Authentication Required$"

        # codium: float when class matches codium variants but exclude when title contains codium/VSCodium
        "float, class:^(codium|codium-url-handler|VSCodium)$, title:negative:^.*(?:codium|VSCodium).*$"

        # Heroic: when class matches the Heroic package but title is not the launcher window
        "float, class:^(com.heroicgameslauncher.hgl)$, title:negative:^.*Heroic Games Launcher.*$"

        # Steam: float when class is Steam and title does not equal "Steam" (explicit substring negative)
        "float, class:^([Ss]team)$, title:negative:^.*[Ss]team.*$"

        "float, class:^([Tt]hunar)$, title:negative:^.*[Tt]hunar.*$"

        "float, initialTitle:^Add Folder to Workspace.*$"
        "float, initialTitle:^Open Files.*$"
        "float, initialTitle:^wants to save.*$"
        "float, title:^Open File.*$"
        "float, title:^Select a File.*$"
        "float, title:^Choose wallpaper.*$"
        "float, title:^Open Folder.*$"
        "float, title:^Save As.*$"
        "float, title:^Library.*$"

        "size 70% 60%, initialTitle:^Open Files.*$"
        "size 70% 60%, initialTitle:^Add Folder to Workspace.*$"
        "size 70% 70%, tag:settings*"
        "size 60% 70%, class:^([Ff]erdium)$"

        "opacity 1.0 1.0, tag:browser*"
        "opacity 0.9 0.8, tag:projects*"
        "opacity 0.94 0.86, tag:im*"
        "opacity 0.9 0.8, tag:file-manager*"
        "opacity 0.8 0.7, tag:terminal*"
        "opacity 0.8 0.7, tag:settings*"
        "opacity 0.8 0.7, class:^(gedit|org.gnome.TextEditor|mousepad)$"
        "opacity 0.9 0.8, class:^(seahorse)$" # gnome-keyring gui
        "opacity 0.95 0.75, title:^Picture-in-Picture$"

        "pin, title:^Picture-in-Picture$"
        "keepaspectratio, title:^Picture-in-Picture$"

        "noblur, tag:games*"
        "fullscreen, tag:games*"
      ];
      layerrule = [
      ];
      misc = {
        focus_on_activate = true;
      };
    };
  };
}
