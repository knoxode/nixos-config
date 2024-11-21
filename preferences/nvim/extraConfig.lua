-- Import existing lspconfig defaults
local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

-- Add `nil_ls` to the list of default servers
local servers = { "html", "cssls", "nil_ls", "r_language_server" }

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

