{...}: {
  programs.nvf.settings.vim.lsp.harper-ls.settings = {
    diagnosticSeverity = "hint";
    dialect = "British";
    linters = {
      OrthographicConsistency = false;
    };
  };
}
