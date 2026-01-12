{...}: {
  programs.nvf = {
    settings.vim = {
      diagnostics = {
        enable = true;
        config = {
          virtual_lines.enable = true;
          underline = true;
        };
      };
    };
  };
}
