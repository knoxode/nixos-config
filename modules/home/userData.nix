{lib, ...}: {
  options.alexos.user = {
    profilePicture = lib.mkOption {
      type = lib.types.enum ["jpg" "png"];
      default = "png";
      description = "File extension for the profile picture in the asset bucket.";
    };

    wallpaper = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Wallpaper filename under ~/Pictures/DesktopBackground.";
    };

    assets = lib.mkOption {
      type = lib.types.submodule {
        options = {
          wallpapers = lib.mkOption {
            type = lib.types.str;
            default = "";
          };
          profile = lib.mkOption {
            type = lib.types.str;
            default = "";
          };
        };
      };
      default = {};
      description = "SHA-256 hashes for the fetched desktop assets.";
    };

    obsidian = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the Obsidian nvf integration and keymaps.";
      };
    };
  };
}
