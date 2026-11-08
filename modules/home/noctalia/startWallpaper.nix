{
  config,
  pkgs,
  ...
}: let
  wallpapersJson = builtins.toJSON {
    defaultWallpaper = "${config.home.homeDirectory}/Pictures/DesktopBackground/${config.alexos.user.wallpaper}";
  };
in {
  home.file.".cache/noctalia/wallpapers.json".source =
    pkgs.writeText "wallpapers.json" wallpapersJson;
}
