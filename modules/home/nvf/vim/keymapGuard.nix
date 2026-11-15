{
  config,
  lib,
  options,
  ...
}: let
  inherit (lib) attrByPath concatStringsSep hasInfix hasPrefix length take;

  vim = config.programs.nvf.settings.vim;
  optTree = (options.programs.nvf.settings.type.getSubOptions []).vim;

  # Option paths shaped like vim.<...>.mappings.<name>, descending submodules.
  mappingPaths = path: node:
    if !(builtins.isAttrs node)
    then []
    else if (node._type or null) == "option"
    then
      (
        if (node.type.name or "") == "submodule"
        then mappingPaths path (node.type.getSubOptions [])
        else []
      )
    else
      lib.concatLists (lib.mapAttrsToList
        (n: c:
          if n == "_module" || n == "_freeformOptions"
          then []
          else if n == "mappings" && builtins.isAttrs c
          then map (mn: path ++ ["mappings" mn]) (builtins.attrNames c)
          else mappingPaths (path ++ [n]) c)
        node);

  # Every ancestor attrset carrying an `enable` must be enabled.
  enabledAt = p:
    builtins.all
    (pre: let
      v = attrByPath pre null vim;
    in
      !(builtins.isAttrs v && v ? enable) || v.enable)
    (lib.genList (i: take (i + 1) p) (length p - 1));

  builtinKeys =
    lib.concatMap
    (p: let
      v = attrByPath p null vim;
    in
      lib.optional (builtins.isString v && v != "") v)
    (builtins.filter enabledAt (mappingPaths [] optTree));

  # User maps are the ones nvf did not generate; plugin-generated entries carry
  # a " [Plugin]" suffix in their description.
  isUserMap = m:
    (m.key or null)
    != null
    && hasPrefix "<leader>" m.key
    && ((m.desc or null) == null || !(hasInfix "[" m.desc));

  userKeys = map (m: m.key) (builtins.filter isUserMap (vim.keymaps or []));

  conflicts =
    lib.concatMap
    (u:
      lib.concatMap
      (b: lib.optional (u == b || hasPrefix u b || hasPrefix b u) "${u} (yours) vs ${b} (nvf)")
      builtinKeys)
    userKeys;
in {
  assertions = [
    {
      assertion = conflicts == [];
      message = ''
        Your keymaps collide with nvf defaults:
        ${concatStringsSep "\n" conflicts}
      '';
    }
  ];
}
