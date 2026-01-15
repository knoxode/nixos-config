{...}: {
  wayland.windowManager.hyprland = {
    settings = {
      layerrule = [
        #Layer Rule for Noctalia Bar and Panel Backgrounds
        "match:namespace noctalia-background-.*$, ignore_alpha 0.5, blur on, blur_popups on"
      ];
    };
  };
}
