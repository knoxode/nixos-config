{config, ...}: {
  programs.nvf = {
    settings.vim = {
      notify = {
        nvim-notify.enable = true;
        nvim-notify.setupOpts.background_colour = "#${config.lib.stylix.colors.base01}";
      };
    };
  };
}
