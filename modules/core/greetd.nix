{
  pkgs,
  config,
  ...
}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland"; # start Hyprland with a TUI login manager
      };
    };
    useTextGreeter = true;
  };
}
