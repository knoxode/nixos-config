{ 
  lib,
  ... 
}:
{
  home.file.".config/hypr/scripts/" = lib.mkDefault {
    source = ./../../../dotfiles/hypr/scripts;
    executable = true;
    recursive = true;
  };
}
