{config, ...}: let
  mainUserProfile = builtins.toString config.home.username;
in {
  stylix = {
    enable = true;
    polarity = "dark";
    targets = {
      hyprland.enable = false;
      firefox = {
        enable = true;
        profileNames = [mainUserProfile];
      };
      nvf.enable = false;
    };
  };
}
