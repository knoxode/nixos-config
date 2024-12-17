local M = {}

M.general = {
  n = {
    ["<C-h>"] = {"<cmd> TmuxNavigateLeft<CR>","window left", {desc = "Move left in tmux"}},
    ["<C-l>"] = {"<cmd> TmuxNavigateRight<CR>","window right", {desc = "Move right in tmux"}},
    ["<C-j>"] = {"<cmd> TmuxNavigateDown<CR>","window down", {desc = "Move down in tmux"}},
    ["<C-k>"] = {"<cmd> TmuxNavigateUp<CR>","window up", {desc = "Move up in tmux"}}
  }
}

return M
