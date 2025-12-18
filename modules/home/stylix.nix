{config, ...}: let
  mainUserProfile = builtins.toString config.home.username;
in {
  stylix = {
    enable = true;
    polarity = "dark";
    targets = {
      hyprland.enable = false;
      hyprlock.enable = false;
      firefox = {
        enable = true;
        profileNames = [mainUserProfile];
      };
    };
  };
}
