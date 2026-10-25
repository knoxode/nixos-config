{...}: {
  programs.nvf.settings.vim.assistant.codecompanion-nvim.setupOpts = {
    mcp = {
      servers.nixos = {
        cmd = ["mcp-nixos"];
      };
    };
  };
}
