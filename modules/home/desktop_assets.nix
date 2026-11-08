{
  config,
  pkgs,
  ...
}: let
  user = config.alexos.user;

  mainUrl = "https://pub-5091b3de9360409687d69cad055e35dc.r2.dev";
  wallpapers = pkgs.fetchurl {
    url = "${mainUrl}/${config.home.username}/DesktopBackground.tar.gz";
    sha256 = user.assets.wallpapers;
  };
  profilePic = pkgs.fetchurl {
    url = "${mainUrl}/${config.home.username}/profile.${user.profilePicture}";
    sha256 = user.assets.profile;
  };
in {
  home.file."Pictures/DesktopBackground".source = pkgs.runCommand "extractWallpapers" {} ''
    mkdir -p $out
    tar -xzf ${wallpapers} -C $out
  '';
  home.file.".face".source = profilePic;
}
