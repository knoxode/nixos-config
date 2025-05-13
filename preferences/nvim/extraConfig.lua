-- Import existing lspconfig defaults
local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

-- Add `nil_ls` to the list of default servers
local servers = { "html", "cssls", "nil_ls", "r_language_server", "pyright", "bashls", "nextflow_ls" }

-- Iterate over servers and apply default configuration
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

vim.filetype.add({
  extension = {
    nf = "nextflow",
  },
})

--Add Nextflow server
lspconfig.nextflow_ls.setup {
  cmd = { "java", "-jar", "/home/shaiikura/Documents/syncthing/asr/language-servers/language-server-all.jar" },
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    nextflow = {
      files = {
        exclude = { ".git", ".nf-test", "work" },
      },
    },
  },
}

-- Provide custom settings for `nil_ls`
lspconfig.nil_ls.setup {
  settings = {
    ["nil"] = {
      nix = {
        format = {
          command = { "nixpkgs-fmt" }, -- Specify the formatter
        },
      },
    },
  },
}

lspconfig.pyright.setup {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = 'basic',
      }
    }
  }
}

lspconfig.clangd.setup {
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git"),
}

lspconfig.bashls.setup {
  filetypes = {"sh", "bash", "zsh", "sbatch"},
}

-- Configure Black formatter using `null-ls.nvim`
local null_ls = require "null-ls"

null_ls.setup {
  sources = {
    null_ls.builtins.formatting.black.with { extra_args = { "--fast" }},
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.prettier,
    require("none-ls.diagnostics.eslint_d"),
    null_ls.builtins.formatting.clang_format
  },
  vim.keymap.set('n', '<leader>gf', vim.lsp.buf.format, {})

}

local nvimtree = require("nvim-tree")

-- Load the default configuration
local config = {
  filters = { dotfiles = false },
  disable_netrw = true,
  hijack_cursor = true,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  view = {
    width = 30,
    preserve_window_proportions = true,
  },
  renderer = {
    root_folder_label = false,
    highlight_git = true,
    indent_markers = { enable = true },
    icons = {
      glyphs = {
        default = "󰈚",
        folder = {
          default = "",
          empty = "",
          empty_open = "",
          open = "",
          symlink = "",
        },
        git = { unmerged = "" },
      },
    },
  },
}

-- Override the specific setting
config.filters.git_ignored = false -- Show files ignored by .gitignore

-- Register external parser for nextflow (custom install)
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

parser_config.nextflow = {
  install_info = {
    url = "https://github.com/matthuska/tree-sitter-nextflow", -- Git repo
    files = { "src/parser.c" }, -- Only this file is needed
    branch = "main", -- Or whatever the correct branch is
  },
  filetype = "nextflow",
}
vim.treesitter.language.register('nextflow', 'nextflow') -- for Neovim ≥ 0.9

-- Apply the configuration
nvimtree.setup(config)
