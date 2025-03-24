{
  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -la";
      logout = "hyprctl dispatch exit";
      man-nixos = "man configuration.nix";
      man-hm = "man home-configuration.nix";
      setup_nix_env = "echo 'use nix' > .envrc && direnv allow";
      arc-login = "ssh -X reub0524@arc-login.arc.ox.ac.uk || ssh -X reub0524@gateway.arc.ox.ac.uk 'ssh -X reub0524@arc-login.arc.ox.ac.uk'";
      arc-htc = "ssh -X reub0524@htc-login.arc.ox.ac.uk || ssh -X reub0524@gateway.arc.ox.arc.ox.ac.uk 'ssh -X reub0524@arc-login.arc.ox.ac.uk'";
    };
    initExtra = ''
      # Initialize Starship prompt
      eval "$(starship init bash)"
      export MANPAGER='nvim +Man!'
      eval "$(direnv hook bash)"


    '';
  };
}

