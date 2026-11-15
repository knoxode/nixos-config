# Neovim Lua

Lua for the Neovim configuration lives here as real `.lua` files, not as inline
strings inside `modules/home/nvf/vim/*.nix`. Inline Lua is invisible to
lua-language-server, so it never gets linted or completed.

Files in this directory are sourced with
`programs.nvf.settings.vim.extraLuaFiles`, which runs them with `:luafile` at
startup. Nix-side keymaps should call a command defined here
(`action = "<cmd>SomeCommand<CR>"`) rather than embedding `:lua ...` snippets.

The only exception is a plugin option that nvf types as a Lua value (e.g.
obsidian's `note_id_func`): reference a named function there, never logic.
