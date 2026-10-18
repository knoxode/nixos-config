{pkgs, ...}: {
  programs.yazi = {
    enable = true;
    inherit (import ./yazi.nix) settings;
    inherit (import ./keymap.nix) keymap;
    inherit (import ./theme.nix) theme;
    shellWrapperName = "y";
    plugins = with pkgs.yaziPlugins; {
      lazygit.package = lazygit;
      full-border.package = full-border;
      git.package = git;
      smart-enter.package = smart-enter;
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
