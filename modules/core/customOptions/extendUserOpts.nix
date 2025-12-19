{
  lib,
  config,
  ...
}:
with lib; {
  options.users.users = mkOption {
    type = types.attrsOf (types.submodule ({
      name,
      config,
      ...
    }: {
      options = {
        firstname = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            This option allows a users first name to be held in a config option.
            Generated from users.users.<name>.desciption, unless provided manually.
          '';
        };
        lastname = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            This option allows a users last name to be held in a config option.
            Generated from users.users.<name>.desciption, unless provided manually.

          '';
        };
      };
      config = mkMerge [
        {
          # set defaults derived from description, but allow explicit overrides
          firstname = mkDefault (
            let
              parts =
                if config.description == ""
                then []
                else splitString " " config.description;
            in
              if builtins.length parts == 0
              then null
              else builtins.elemAt parts 0
          );
          lastname = mkDefault (
            let
              parts =
                if config.description == ""
                then []
                else splitString " " config.description;
            in
              if builtins.length parts == 0
              then null
              else builtins.elemAt parts 0
          );
        }
      ];
    }));
  };
}
