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
      # Not used in this config; the stylix target sets deprecated
      # `programs.rofi.font`, which triggers a home-manager rename warning.
      rofi.enable = false;
      # The stylix target sets `programs.opencode.tui`, which OpenCode 2
      # ignores and which triggers an evaluation warning.
      opencode.enable = false;
      firefox = {
        enable = true;
        profileNames = [mainUserProfile];
      };
      nvf.enable = false;
    };
  };
}
