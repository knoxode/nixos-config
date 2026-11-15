{...}: {
  programs.nvf = {
    settings.vim = {
      statusline.lualine = {
        enable = true;
        integrations.breadcrumbs = {
          navbuddy.enable = true;
        };
      };

      tabline.nvimBufferline = {
        enable = true;
        # <leader>bn / <leader>bp cycle, <leader>bc picks, <leader>bmn / bmp
        # move. Closing was unbound (mouse-only); bufdelete keeps the layout.
        mappings.closeCurrent = "<leader>bd";
      };
    };
  };
}
