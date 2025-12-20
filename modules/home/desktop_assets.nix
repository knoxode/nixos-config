{
  lib,
  pkgs,
  config,
  ...
}: let
  username = config.home.username;
  # map each username to the sha256s for the assets they need
  profileFileExt =
    if username == "shaiikura"
    then "jpg"
    else "png";
  userHashes = {
    shaiikura = {
      wallpapers = "1crgh0rmraj0jysshxw51v39982yh9qw2ynylvjvhnk65yg235bm";
      profile = "0kxjiyn0yh6fsijc0m6mscwy1vivi8pv7pixsbjx2idwwss6l30z";
    };
    kuchikopi = {
      wallpapers = "169r4zscncx3sb7nhxwj1rn5hd4jsinc9g0kpp2zy6bvkrdvmadl";
      profile = "17p5rzmisflr1vfc91ysaacikxr00g31n0laaal261901k8cq8k7";
    };
    # default / fallback entry optional
    default = {
      wallpapers = "0000000000000000000000000000000000000000000000000000";
      hyprlock = "0000000000000000000000000000000000000000000000000000";
    };
  };
  # choose the hashes for this username (or fallback/throw)
  hashes =
    if builtins.hasAttr username userHashes
    then userHashes.${username}
    else lib.throw "No asset hashes configured for user: ${username}";

  mainUrl = "https://pub-5091b3de9360409687d69cad055e35dc.r2.dev";
  hyprlockAssets = pkgs.fetchurl {
    url = "${mainUrl}/hyprlock.tar.gz";
    sha256 = "0sssngsc417yj0hzdcqwm2j5idiqg00c9aq47d1sjlrp0cjvwhc8";
  };
  wallpapers = pkgs.fetchurl {
    url = "${mainUrl}/${username}/DesktopBackground.tar.gz";
    sha256 = hashes.wallpapers;
  };
  profilePic = pkgs.fetchurl {
    url = "${mainUrl}/${username}/profile.${profileFileExt}";
    sha256 = hashes.profile;
  };
in {
  home.file."Pictures/DesktopBackground".source = pkgs.runCommand "extractWallpapers" {} ''
    mkdir -p $out
    tar -xzf ${wallpapers} -C $out
  '';

  xdg.configFile."hypr/hyprlockassets".source = pkgs.runCommand "extractHyprlockAssets" {} ''
    mkdir -p $out
    tar -xzf ${hyprlockAssets} -C $out
  '';
  home.file.".profilePic.${profileFileExt}".source = profilePic;
}
