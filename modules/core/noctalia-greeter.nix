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
    };
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };
    passwordlessSyncUsers = lib.attrNames (lib.filterAttrs (_: user: user.isNormalUser) config.users.users);
  };
}
