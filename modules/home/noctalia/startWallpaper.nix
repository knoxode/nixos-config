{
  config,
  pkgs,
  ...
}: let
  wallpaperPath =
    if config.home.username == "kuchikopi"
    then "wallhaven-7j3lve.png"
    else if config.home.username == "shaiikura"
    then "wallhaven-2y7q2y.png"
    else "";

  wallpapersJson = builtins.toJSON {
    defaultWallpaper = "/home/${config.home.username}/Pictures/DesktopBackground/${wallpaperPath}";
  };
in {
  home.file.".cache/noctalia/wallpapers.json".source =
    pkgs.writeText "wallpapers.json" wallpapersJson;
}
