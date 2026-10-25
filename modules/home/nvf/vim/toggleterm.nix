{lib, ...}: {
  programs.nvf.settings.vim.terminal.toggleterm = {
    enable = true;

    setupOpts = {
      direction = "float";

      winbar.enabled = true;
      float_opts = {
        border = "rounded";
        #width = lib.generators.mkLuaInline "function() return math.floor(vim.o.columns * 0.8) end";
        #height = lib.generators.mkLuaInline "function() return math.floor(vim.o.lines * 0.8) end";
        winblend = 3;
      };
    };

    lazygit.enable = true;
  };
}
