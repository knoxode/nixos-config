{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -la";
    };
    initExtra = ''
      # Initialize Starship prompt
      eval "$(starship init bash)"
      fastfetch
    '';
  };
}

