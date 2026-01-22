{...}: {
  programs.nvf = {
    settings.vim = {
      statusline.lualine = {
        enable = true;
      };

      tabline.nvimBufferline.enable = true;
    };
  };
}
