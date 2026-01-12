{...}: {
  programs.nvf = {
    settings.vim = {
      statusline.lualine = {
        enable = true;
        theme = "base16";
      };

      tabline.nvimBufferline.enable = true;
    };
  };
}
