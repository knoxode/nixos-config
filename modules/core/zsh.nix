# System-level zsh wiring (env, PATH setup) required by any user whose
# shell is pkgs.zsh, including root. Per-user configuration is Home-Manager
# (modules/home/zsh).
_: {
  programs.zsh.enable = true;
}
