-- Import existing lspconfig defaults
local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

-- Add `nil_ls` to the list of default servers
local servers = { "html", "cssls", "nil_ls", "r_language_server", "pyright" }

-- Iterate over servers and apply default configuration
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

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

-- Configure Black formatter using `null-ls.nvim`
local null_ls = require "null-ls"

null_ls.setup {
  sources = {
    null_ls.builtins.formatting.black.with { extra_args = { "--fast" }},
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.prettier,
    require("none-ls.diagnostics.eslint_d"),
  },
  vim.keymap.set('n', '<leader>gf', vim.lsp.buf.format, {})

}
