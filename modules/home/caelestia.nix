{username, ...}: {
  programs.caelestia = {
    enable = true;
    systemd = {
      enable = false; # if you prefer starting from your compositor
    };
    settings = {
      bar.workspaces = {
        "activeIndicator" = true;
        "activeLabel" = "󰮯";
        "activeTrail" = false;
        "label" = "  ";
        "occupiedBg" = false;
        "occupiedLabel" = "󰮯";
        "perMonitorWorkspaces" = true;
        "showWindows" = true;
        "shown" = 5;
      };
      paths.wallpaperDir = "/home/${username}/Pictures/DesktopBackground";
      services = {
        "weatherLocation" = "";
      };
    };
    cli = {
      enable = true;
      settings = {
        theme.enableGtk = false;
        theme.enableQt = false;
      };
    };
  };
}
