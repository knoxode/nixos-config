{pkgs, ...}: {
  programs.yazi = {
    enable = true;
    inherit (import ./yazi.nix) settings;
    inherit (import ./keymap.nix) keymap;
    inherit (import ./theme.nix) theme;
    shellWrapperName = "y";
    plugins = {
      lazygit = pkgs.yaziPlugins.lazygit;
      full-border = pkgs.yaziPlugins.full-border;
      git = pkgs.yaziPlugins.git;
      smart-enter = pkgs.yaziPlugins.smart-enter;
    };

    initLua = ''
      require("full-border"):setup()
         require("git"):setup()
         require("smart-enter"):setup {
           open_multi = true,
         }
    '';
  };
}
