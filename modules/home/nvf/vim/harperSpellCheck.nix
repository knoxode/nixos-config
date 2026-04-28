{...}: {
  programs.nvf.settings.vim.lsp.servers.harper.settings = {
    diagnosticSeverity = "hint";
    dialect = "British";
    linters = {
      OrthographicConsistency = false;
    };
  };
}
