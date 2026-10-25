{...}: {
  programs.nvf.settings.vim.assistant = {
    chatgpt.enable = false;

    copilot = {
      enable = false;
      cmp.enable = false;
    };
  };
}
