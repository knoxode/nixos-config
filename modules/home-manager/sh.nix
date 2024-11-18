{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -la";
    };
    initExtra = ''
      # export TERM=xterm-256color
      eval "$(starship init bash)"
    '';
  };
}

