# Neovim Keybindings (nvf)

**Source**: `modules/home/nvf/vim/*.nix`  
**Leader**: `<leader> = SPACE` (via which-key preset)

---

## General

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `jk` | Insert | Exit insert mode | `keymaps.nix` |
| `<leader>e` | Normal | Toggle Neotree | `keymaps.nix` |
| `<leader>nh` | Normal | Clear search highlights | `keymaps.nix` |
| `<leader>nb` | Normal | Open Navbuddy | `keymaps.nix` |
| `<leader>ff` | Normal | Telescope find files | `keymaps.nix` |
| `<leader>lg` | Normal | Telescope live grep | `keymaps.nix` |
| `<leader>fe` | Normal | File browser toggle | `keymaps.nix` |

---

## Insert Mode Navigation

| Key | Action |
|-----|--------|
| `<C-h>` | Left |
| `<C-j>` | Down |
| `<C-k>` | Up |
| `<C-l>` | Right |

---

## Diagnostics

| Key | Action |
|-----|--------|
| `<leader>dj` | Next diagnostic (Lspsaga) |
| `<leader>dk` | Previous diagnostic (Lspsaga) |
| `<leader>dl` | Show line diagnostics (Lspsaga) |
| `<leader>dt` | Toggle diagnostics list (Trouble) |

---

## Obsidian (when enabled)

| Key | Action |
|-----|--------|
| `<leader>oo` | Open note under cursor |
| `<leader>off` | Quick switch (fuzzy find) |
| `<leader>ofg` | Search vault |
| `<leader>on` | New note |
| `<leader>ob` | Show backlinks |
| `<leader>ot` | Open today's note |
| `<leader>opi` | Paste image from clipboard |

---

## smart-splits.nvim (if enabled)

| Key | Action | Conflict |
|-----|--------|----------|
| `<C-h/j/k/l>` | Focus window/pane | **Ghostty `CTRL+SHIFT+h/j/k/l`** |
| `<A-h/j/k/l>` | Resize window/pane | Ghostty unbound |
| `<leader><leader>h/j/k/l>` | Swap buffer | None |

> **Note**: smart-splits is available via nvf but not explicitly enabled in your config. If enabled, `CTRL+h/j/k/l` conflicts with Ghostty's split navigation (Ghostty uses `CTRL+SHIFT`, Neovim uses `CTRL`).

---

## LSP (nvf defaults via nvim-lspconfig)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | References |
| `K` | Hover |
| `<leader>rn` | Rename |
| `<leader>ca` | Code action |
| `[d` / `]d` | Prev/next diagnostic |

---

## Treesitter / Navigation (nvf defaults)

| Key | Action |
|-----|--------|
| `]f` / `[f` | Next/prev function |
| `]c` / `[c` | Next/prev class |
| `]a` / `[a` | Next/prev argument |

---

## Git (gitsigns.nvim via nvf)

| Key | Action |
|-----|--------|
| `]h` / `[h` | Next/prev hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |

---

## Verification

```vim
" Check leader key
:echo mapleader

" List all keymaps
:map

" Check specific key
:verbose map <leader>ff
```