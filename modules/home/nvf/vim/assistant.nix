{...}: {
  programs.nvf.settings.vim.assistant = {
    chatgpt.enable = false;
    copilot = {
      enable = false;
      cmp.enable = true;
    };
    codecompanion-nvim.enable = false;
    avante-nvim.enable = true;
  };
}
