{pkgs, ...}: {
  programs.yazi = {
    enable = true;
    inherit (import ./yazi.nix) settings;
    inherit (import ./keymap.nix) keymap;
    #inherit (import ./theme.nix) theme;
    shellWrapperName = "y";
    plugins = with pkgs.yaziPlugins; {
      lazygit.package = lazygit;
      full-border = {
        package = full-border;
        setup = true;
      };
      git = {
        package = git;
        setup = true;
      };
      smart-enter = {
        package = smart-enter;
        setup = true;
        settings = {
          open_multi = true;
        };
      };
    };
  };
}
