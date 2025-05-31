{...}: {
  home.file.".config/hypr/scripts/battery-status.sh" = {
    source = ./../../../dotfiles/hypr/scripts/battery-status.sh;
    executable = true;
  };
  home.file.".config/hypr/scripts/playerctlock.sh" = {
    source = ./../../../dotfiles/hypr/scripts/playerctlock.sh;
    executable = true;
  };
  home.file.".config/hypr/scripts/weather_location.sh" = {
    source = ./../../../dotfiles/hypr/scripts/weather_location.sh;
    executable = true;
  };
  home.file.".config/hypr/scripts/wifi-status.sh" = {
    source = ./../../../dotfiles/hypr/scripts/wifi-status.sh;
    executable = true;
  };
  home.file.".config/hypr/scripts/news.sh" = {
    source = ./../../../dotfiles/hypr/scripts/news.sh;
    executable = true;
  };
}
