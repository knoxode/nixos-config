{...}: {
  programs.nvf = {
    settings.vim = {
      spellcheck = {
        enable = true;
        languages = ["en"];
        # Alias'd to dirtyTalk in the manual
        programmingWordlist.enable = true;
        extraSpellWords = {
          "en.utf-8" = [
            "nvf"
          ];
        };
        ignoredFiletypes = [
          "toggleterm"
          "gitcommit"
          "text"
        ];
      };

      lsp = {
        enable = true;
        formatOnSave = true;
        lspkind.enable = false;
        lightbulb.enable = true;
        lspsaga.enable = false;
        trouble.enable = true;
        lspSignature.enable = false; # conflicts with blink in maximal
        otter-nvim.enable = true;
        nvim-docs-view.enable = true;
        servers = {
          harper.enable = true;
        };

        presets = {
          harper.enable = true;
          tailwindcss-language-server = {
          };
        };
      };

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;
        bash.enable = true;
        nix = {
          enable = true;
          lsp.servers = ["nixd"];
        };
        clang.enable = true;
        zig.enable = false;
        python.enable = true;
        markdown = {
          enable = true;
          extensions = {
            render-markdown-nvim = {
              enable = true;
              setupOpts = {
                file_types = ["markdown"];
              };
            };
          };
        };
        typescript = {
          enable = true;
          lsp.enable = true;
          format.type = ["prettierd"];
          extensions.ts-error-translator.enable = true;
        };
        html.enable = false;
        lua.enable = true;
        css.enable = true;
        typst.enable = true;
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
