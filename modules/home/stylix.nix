{
  config,
  pkgs,
  ...
}: let
  mainUserProfile = toString config.home.username;
in {
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";
    targets = {
      hyprland.enable = false;
      ghostty.enable = false;
      firefox = {
        enable = true;
        profileNames = [mainUserProfile];
      };
      nvf.enable = false;
    };
  };
}
