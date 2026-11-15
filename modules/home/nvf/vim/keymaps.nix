{...}: {
  programs.nvf = {
    settings.vim = {
      maps = {
        normal = {
          "<leader>e" = {
            action = "<CMD>Neotree toggle<CR>";
            silent = false;
          };
        };
      };

      keymaps = [
        {
          key = "jk";
          mode = ["i"];
          action = "<ESC>";
          desc = "Exit insert mode";
        }
        {
          key = "<leader>nh";
          mode = ["n"];
          action = ":nohl<CR>";
          desc = "Clear search highlights";
        }
        {
          key = "<leader>nb";
          mode = ["n"];
          action = ":Navbuddy<CR>";
          desc = "Open Navbuddy";
        }
        # <leader>ff (find files) and <leader>fg (live grep) come from nvf's
        # telescope defaults. Do not reuse <leader>l*: nvf reserves it for LSP
        # (<leader>lgd, <leader>lgr, ...).
        {
          key = "<leader>fe";
          mode = ["n"];
          action = "<cmd>Neotree toggle<cr>";
          desc = "File browser toggle";
        }
        {
          key = "<C-h>";
          mode = ["i"];
          action = "<Left>";
          desc = "Move left in insert mode";
        }
        {
          key = "<C-j>";
          mode = ["i"];
          action = "<Down>";
          desc = "Move down in insert mode";
        }
        {
          key = "<C-k>";
          mode = ["i"];
          action = "<Up>";
          desc = "Move up in insert mode";
        }
        {
          key = "<C-l>";
          mode = ["i"];
          action = "<Right>";
          desc = "Move right in insert mode";
        }
        {
          key = "<leader>dj";
          mode = ["n"];
          action = "<cmd>NixDiagNext<CR>";
          desc = "Go to next diagnostic";
        }
        {
          key = "<leader>dk";
          mode = ["n"];
          action = "<cmd>NixDiagPrev<CR>";
          desc = "Go to previous diagnostic";
        }
        {
          key = "<leader>dl";
          mode = ["n"];
          action = "<cmd>NixDiagFloat<CR>";
          desc = "Show diagnostic details";
        }
        {
          key = "<leader>dt";
          mode = ["n"];
          action = "<cmd>Trouble diagnostics toggle<cr>";
          desc = "Toggle diagnostics list";
        }
        # nixd only offers a quickfix when the requested range overlaps the
        # diagnostic; the default <leader>la sends just the cursor position.
        {
          key = "<leader>lA";
          mode = ["n"];
          action = "<cmd>CodeActionLine<CR>";
          desc = "Code actions for the whole line";
        }
      ];
    };
  };
}
