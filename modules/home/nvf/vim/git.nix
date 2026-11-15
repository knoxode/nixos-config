{...}: {
  programs.nvf = {
    settings.vim = {
      git = {
        enable = true;
        gitsigns = {
          enable = true;
          codeActions.enable = false;
          # nvf defaults this to <leader>td, which is a prefix of
          # todo-comments' <leader>td{q,s,t}.
          mappings.toggleDeleted = "<leader>hx";
        };
      };
    };
  };
}
