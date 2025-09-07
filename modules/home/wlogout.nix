{pkgs, ...}: let
  wlogoutIcons = pkgs.fetchurl {
    url = "https://pub-5091b3de9360409687d69cad055e35dc.r2.dev/wlogout.tar.gz";
    sha256 = "10zvbhl5a7jg8qasma1vb0f62dagf8y8qn0xabsd6f8b22m2dgh9";
  };
in {
  home.file.".config/wlogout" = {
    source = pkgs.runCommand "wlogout-config" {} ''
      mkdir -p $out

      # Copy layout + style.css from your repo
      cp ${./../../dotfiles/wlogout/layout} $out/layout
      cp ${./../../dotfiles/wlogout/style.css} $out/style.css

      # Extract icons into icons/
      mkdir -p $out/icons
      tar -xzf ${wlogoutIcons} -C $out/icons
    '';
  };
}
