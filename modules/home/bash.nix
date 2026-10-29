{config, ...}: {
  programs.bash = {
    enable = true;
    shellAliases = config.commonShellAliases;
    initExtra = ''
      export MANPAGER='nvim +Man!'
      eval "$(direnv hook bash)"
    '';
  };
}
