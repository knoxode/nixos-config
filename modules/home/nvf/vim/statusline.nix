{...}: {
  programs.nvf = {
    settings.vim = {
      statusline.lualine = {
        enable = true;
        integrations.breadcrumbs = {
          navbuddy.enable = true;
        };
      };

      tabline.nvimBufferline.enable = true;
    };
  };
}
