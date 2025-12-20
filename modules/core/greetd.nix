{
  pkgs,
  config,
  ...
}: let
  hyprCmd =
    if config.hyprOnMain
    then "start-hyprland"
    else "Hyprland";
in {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${hyprCmd}"; # start Hyprland with a TUI login manager
      };
    };
    useTextGreeter = true;
  };
}
