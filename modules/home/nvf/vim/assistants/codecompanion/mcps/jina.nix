{pkgs, ...}: {
  programs.nvf.settings.vim.assistant.codecompanion-nvim.setupOpts = {
    mcp = {
      servers.jina = {
        cmd = [
          "${pkgs.nodejs_22}/bin/npx"
          "-y"
          "mcp-remote"
          "https://mcp.jina.ai/v1?include_tools=read_url,search_web&max_tokens=6000"
          "--header"
          "Authorization: Bearer \${JINA_API_KEY}"
        ];
      };

      opts.default_servers = [];
    };
  };
}
