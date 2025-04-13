{
  input = {
    repeat_delay = 350;
    repeat_rate = 50;
  };

  env = [
    "GDK_BACKEND,wayland,x11,*"
    "QT_QPA_PLATFORM,wayland;xcb"
    "SDL_VIDEODRIVER,wayland"
    "CLUTTER_BACKEND,wayland"
    "XDG_CURRENT_DESKTOP,Hyprland"
    "XDG_SESSION_TYPE,wayland"
    "XDG_SESSION_DESKTOP,Hyprland"
  ];
}

