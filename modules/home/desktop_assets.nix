{pkgs, ...}: let
  wallpapers = pkgs.fetchurl {
    url = "https://pub-5091b3de9360409687d69cad055e35dc.r2.dev/DesktopBackground.tar.gz";
    sha256 = "16qqc7qigrg5gwwn2jnh3djny8hy4pavljnd7dwja0mi94hwj97v";
  };

  hyprlockAssets = pkgs.fetchurl {
    url = "https://pub-5091b3de9360409687d69cad055e35dc.r2.dev/hyprlock.tar.gz";
    sha256 = "0sssngsc417yj0hzdcqwm2j5idiqg00c9aq47d1sjlrp0cjvwhc8";
  };
in {
  home.file."Pictures/DesktopBackground".source = pkgs.runCommand "extract-wallpapers" {} ''
    mkdir -p $out
    tar --strip-components=1 -xzf ${wallpapers} -C $out
  '';

  xdg.configFile."hypr/hyprlockassets".source = pkgs.runCommand "extract-hyprlock-assets" {} ''
    mkdir -p $out
    tar -xzf ${hyprlockAssets} -C $out
  '';
}
