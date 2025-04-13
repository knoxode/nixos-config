{
  windowrule = [
    "opacity 0.8 override,class:kitty"
    "noblur,title:.*"
    "float, class:steam"
    "center, title:^(Open File)(.*)$"
    "center, title:^(Select a File)(.*)$"
    "center, title:^(Choose wallpaper)(.*)$"
    "center, title:^(Open Folder)(.*)$"
    "center, title:^(Save As)(.*)$"
    "center, title:^(Library)(.*)$"
    "center, title:^(File Upload)(.*)$"
    "float,title:^(Open File)(.*)$"
    "float,title:^(Select a File)(.*)$"
    "float,title:^(Choose wallpaper)(.*)$"
    "float,title:^(Open Folder)(.*)$"
    "float,title:^(Save As)(.*)$"
    "float,title:^(Library)(.*)$"
    "float,title:^(File Upload)(.*)$"
    "immediate,title:.*\\.exe"
  ];

  windowrulev2 = [
    "suppressevent maximize, class:.*"
    "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
    "float, title:^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$"
    "immediate,class:(steam_app)"
    "noshadow,floating:0"
  ];

  layerrule = [
    "xray 1, .*"
    "noanim, walker"
    "noanim, selection"
    "noanim, overview"
    "noanim, anyrun"
    "noanim, indicator.*"
    "noanim, osk"
    "noanim, hyprpicker"
    "blur, shell:*"
    "ignorealpha 0.6, shell:*"
    "noanim, noanim"
    "blur, gtk-layer-shell"
    "ignorezero, gtk-layer-shell"
    "blur, launcher"
    "ignorealpha 0.5, launcher"
    "blur, notifications"
    "ignorealpha 0.69, notifications"
  ];
}

