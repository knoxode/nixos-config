{config, ...}: {
  programs.bash = {
    enable = true;
    shellAliases = config.commonShellAliases;
    initExtra = ''
      # Initialize Starship prompt
      eval "$(starship init bash)"
      export MANPAGER='nvim +Man!'
      eval "$(direnv hook bash)"
    '';
  };
}
