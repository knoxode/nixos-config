{...}: {
  programs.nvf = {
    settings.vim = {
      spellcheck = {
        enable = true;
        languages = ["en"];
        programmingWordlist.enable = true;
      };

      lsp = {
        enable = true;
        formatOnSave = true;
        lspkind.enable = false;
        lightbulb.enable = false;
        lspsaga.enable = false;
        trouble.enable = true;
        lspSignature.enable = false;
        otter-nvim.enable = false;
        nvim-docs-view.enable = false;
      };

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;
        bash.enable = true;
        nix.enable = true;
        clang.enable = true;
        zig.enable = true;
        python.enable = true;
        markdown.enable = true;
        ts = {
          enable = true;
          lsp.enable = true;
          format.type = ["prettierd"];
          extensions.ts-error-translator.enable = true;
        };
        html.enable = true;
        lua.enable = true;
        css.enable = true;
        typst.enable = true;
        r.enable = true;
        rust = {
          enable = true;
          extensions = {
            crates-nvim.enable = true;
          };
        };
      };
    };
  };
}
