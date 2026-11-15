{
  pkgs,
  repoRoot,
  ...
}: {
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

      diagnostics = {
        nvim-lint.linters = {
          luacheck = {
            args = [
              "--formatter"
              "plain"
              "--codes"
              "--ranges"
              "--read-globals"
              "hl"
              "-"
            ];
          };
        };
      };

      lsp = {
        enable = true;
        formatOnSave = true;
        lspkind.enable = false;
        lightbulb.enable = true;
        lspsaga.enable = false;
        trouble = {
          enable = true;
          # A centred float hides the buffer you are jumping into. Use a
          # right-hand vertical split instead: the code stays visible and
          # q/<esc> closes it, <cr> jumps, <c-s>/<c-v> jump into a split.
          setupOpts.win = {
            type = "split";
            position = "right";
            # Fraction of the editor width, so it adapts to monitor size
            # (~60 columns on a 200-column terminal).
            size = 0.3;
          };
        };
        lspSignature.enable = false; # conflicts with blink in maximal
        otter-nvim.enable = true;
        nvim-docs-view.enable = true;
        servers = {
          harper.enable = true;
          lua-language-server = {
            settings = {
              Lua = {
                runtime.version = "Lua 5.4";
                workspace.library = [
                  "${pkgs.hyprland}/share/hypr/stubs"
                  "${repoRoot}/modules/home/hyprland"
                  # Neovim `vim.*` API stubs, for the Lua in modules/home/nvf/lua.
                  "${pkgs.neovim-unwrapped}/share/nvim/runtime/lua"
                  "${repoRoot}/modules/home/nvf/lua"
                ];
                diagnostics = {
                  globals = [
                    "hl"
                    # Noctalia calls these by name at the global scope.
                    "OnBatteryHook"
                    "OnACHook"
                  ];
                };
              };
            };
          };
        };

        presets = {
          harper.enable = true;
          tailwindcss-language-server.enable = true;
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
          format.type = ["prettier"];
          extensions.ts-error-translator.enable = true;
        };
        html.enable = false;
        lua.enable = true;
        css.enable = true;
        typst = {
          enable = true;
          extensions = {
            typst-concealer.enable = true;
            typst-preview-nvim.enable = true;
          };
        };
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
