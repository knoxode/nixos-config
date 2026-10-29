{
  lib,
  pkgs,
  config,
  ...
}: {
  services.displayManager.noctalia-greeter = {
    enable = true;
    settings = {
      cursor.size = 24;
      user.default = "shaiikura";
    };
    cursorTheme = {
      # Reuse stylix's single-variant wrapper: the full bibata-cursors package
      # ships all 12 themes (~320 MiB); only Modern-Ice is used anywhere.
      package = config.stylix.cursor.package;
      name = config.stylix.cursor.name;
    };
    passwordlessSyncUsers = lib.attrNames (lib.filterAttrs (_: user: user.isNormalUser) config.users.users);
  };
}
