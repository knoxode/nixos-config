{
  config,
  username,
  ...
}: {
  # OpenRGB's device polling (~700 wakeups/s) keeps the CPU out of deep
  # package C-states, costing ~5 W on the laptop for no benefit — the Razer
  # keyboard runs through openrazer below. Desktop (node) keeps it.
  services.hardware.openrgb.enable = config.alexos.host.openrgb;
  hardware.openrazer = {
    enable = config.alexos.host.razer;
    users = [username];
  };
}
