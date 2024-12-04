{
  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -la";
      logout = "SESSION_ID=$(loginctl | head -n 1 | awk '{print $1}') ; loginctl terminate-session $SESSION_ID";
      man-nixos = "man configuration.nix";
      man-hm = "man home-configuration.nix";
      setup_nix_env = "echo 'use nix' > .envrc && direnv allow";
    };
    initExtra = ''
      # Initialize Starship prompt
      eval "$(starship init bash)"
      export MANPAGER='nvim +Man!'
      eval "$(direnv hook bash)"


    '';
  };
}

