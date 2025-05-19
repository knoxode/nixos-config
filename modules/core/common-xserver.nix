{
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.autoRepeatDelay = 200;
  services.xserver.autoRepeatInterval = 50;
  # Enable the GNOME Display manager and greeter.
  services.xserver.displayManager.gdm.enable = true;

  services.xserver.displayManager.gdm.settings = {
    greeter = {
      exclude = "root";
    };
  };
}
