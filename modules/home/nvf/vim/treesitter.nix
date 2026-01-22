{...}: {
  programs.nvf = {
    settings.vim = {
      treesitter.enable = true;
      treesitter.context.enable = true;
    };
  };
}
