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
      
      # Ensure AGS is initialized
      if [ -x "$(command -v ags)" ]; then
        ags --init
      fi
    '';
  };
}

