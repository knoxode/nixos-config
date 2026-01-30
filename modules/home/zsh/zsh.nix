{
  host,
  config,
  lib,
  pkgs,
  ...
}: let
  initExtraFirst =
    lib.mkOrder 500 ''
    '';
  initExtraBeforeCompInit = lib.mkOrder 550 ''
    # put this before completion initialization
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
    zstyle ':completion:*' list-colors "$${s(.:.)LS_COLORS}"
    zstyle ':completion:*' menu no
  '';
  initExtraLate = lib.mkOrder 1000 ''
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
    zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
  '';
  initExtraLast = lib.mkOrder 1500 ''
    eval "$(direnv hook zsh)"
  '';
in {
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion = {
        enable = true;
        strategy = ["history"];
      };
      plugins = [
        {
          name = "fzf-tab";
          src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
        }
      ];
      defaultKeymap = "emacs";
      syntaxHighlighting.enable = true;
      history = {
        size = 5000;
        ignoreDups = true;
        ignoreAllDups = true;
        ignoreSpace = true;
        saveNoDups = true;
        findNoDups = true;
        append = true;
        path = "${config.xdg.dataHome}/zsh/history";
      };
      initContent = lib.mkMerge [initExtraFirst initExtraBeforeCompInit initExtraLate initExtraLast];
      shellAliases = config.commonShellAliases;
    };
    oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      configFile = ./oh-my-posh.toml;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--cmd cd"
      ];
    };
  };
}
