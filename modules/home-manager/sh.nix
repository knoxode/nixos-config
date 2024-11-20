{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -la";
      man-nixos = "man configuration.nix";
      man-hm = "man home-configuration.nix";
    };
    initExtra = ''
      # Initialize Starship prompt
      eval "$(starship init bash)"
      fastfetch
      export MANPAGER='nvim +Man!'
    '';
  };
}

