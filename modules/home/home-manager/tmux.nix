{
  pkgs,
  ...
}:

{
  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.vim-tmux-navigator
    ];
    extraConfig = ''
      set -g @plugin 'tmux-plugins/tmux-sensible'
      set -g @plugin 'christoomey/vim-tmux-navigator'
    '';
  };
}
