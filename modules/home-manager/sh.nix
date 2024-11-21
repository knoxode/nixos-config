{
  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -la";
      logout = "loginctl terminate-user shaiikura";
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

