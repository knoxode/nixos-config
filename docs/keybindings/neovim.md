# Neovim Keybindings (nvf)

**Source**: `modules/home/nvf/vim/*.nix` (keymaps) and `modules/home/nvf/lua/*.lua` (commands)  
**Leader**: `<leader> = SPACE` (via which-key preset)

Keymaps declared here are checked against nvf's enabled defaults at eval time by
`modules/home/nvf/vim/keymapGuard.nix`: reusing a key (or a prefix of one) that
nvf already maps fails the build with the conflicting pairs listed.

---

## General

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `jk` | Insert | Exit insert mode | `keymaps.nix` |
| `<leader>e` | Normal | Toggle Neotree | `keymaps.nix` |
| `<leader>nh` | Normal | Clear search highlights | `keymaps.nix` |
| `<leader>nb` | Normal | Open Navbuddy | `keymaps.nix` |
| `<leader>ff` | Normal | Telescope find files | nvf default (`telescope`) |
| `<leader>fg` | Normal | Telescope live grep | nvf default (`telescope`) |
| `<leader>fe` | Normal | File browser toggle | `keymaps.nix` |
| `<leader>nf` | Normal | Apply nix lint fixes (deadnix + statix) | `nixFix.nix` → `NixFix` |

> **Note**: `<leader>l*` is reserved by nvf for LSP (`<leader>lgd`, `<leader>lgr`, …),
> so live grep used to sit on `<leader>lg` and would hang waiting for the next key.

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

| Key | Command | Action |
|-----|---------|--------|
| `<leader>dj` | `:NixDiagNext` | Next diagnostic |
| `<leader>dk` | `:NixDiagPrev` | Previous diagnostic |
| `<leader>dl` | `:NixDiagFloat` | Show line diagnostics |
| `<leader>dt` | — | Toggle diagnostics list (Trouble, right split) |

The `NixDiag*` commands live in `modules/home/nvf/lua/nvim-commands.lua`.
All Trouble views open as a right-hand vertical split, 30% of the editor width
(`setupOpts.win = { type = "split"; position = "right"; size = 0.3; }`),
including nvf's `<leader>ld`, `<leader>lwd`, `<leader>lr`, `<leader>xq`,
`<leader>xl`, `<leader>xs`. Inside a Trouble window: `q`/`<esc>` close, `<cr>`
jump, `o` jump and close, `<c-s>`/`<c-v>` jump into a split, `p` preview.

---

## Buffers (nvf bufferline)

| Key | Action |
|-----|--------|
| `<leader>bn` | Next buffer |
| `<leader>bp` | Previous buffer |
| `<leader>bc` | Pick a buffer |
| `<leader>bd` | Close current buffer (`bufdelete`, keeps the window layout) |
| `<leader>bmn` / `<leader>bmp` | Move buffer right / left |
| `<leader>bsd` / `<leader>bse` / `<leader>bsi` | Sort by directory / extension / ID |

---

## Help

`:help` (and `<leader>lh`-style help requests) open in a centred floating
window; `q` closes it. Implemented in
`modules/home/nvf/lua/floating-help.lua`.

---

## Obsidian (when enabled)

| Key | Action |
|-----|--------|
| `<leader>oo` | Open note under cursor |
| `<leader>off` | Quick switch (fuzzy find) |
| `<leader>ofg` | Search vault |
| `<leader>on` | New note in a chosen folder (fuzzy folder picker, then title) |
| `<leader>oc` | New note in the current directory (native `:Obsidian new`) |
| `<leader>ob` | Show backlinks |
| `<leader>ot` | Open today's note |
| `<leader>opi` | Paste image from clipboard |

`<leader>on` (`:ObsidianNewInFolder`, `modules/home/nvf/lua/obsidian.lua`) lists
the vault's folders, then prompts for a title and creates the note there. The
last folder used is offered first, so repeated meeting/seminar notes are two
`<cr>` presses. Notes are still slugged by title (`note_id_func = title_id`).

`<leader>oc` is plain `:Obsidian new`: it uses `new_notes_location =
"current_dir"`, i.e. the directory of the note you are in, falling back to the
vault root when the current buffer is not a note. `<leader>oc` rather than
`<leader>onc` because `on` is a prefix of `onc`, which would make `<leader>on`
wait for `timeoutlen` before firing.

---

## smart-splits.nvim (enabled in `utility.nix`)

| Key | Action | Conflict |
|-----|--------|----------|
| `<C-h/j/k/l>` | Focus window/pane | **Ghostty `CTRL+SHIFT+h/j/k/l`** |
| `<A-h/j/k/l>` | Resize window/pane | Ghostty unbound |
| `<leader><leader>h/j/k/l>` | Swap buffer | None |

> **Note**: `CTRL+h/j/k/l` in normal mode conflicts with Ghostty's split navigation
> (Ghostty uses `CTRL+SHIFT`, Neovim uses `CTRL`). The insert-mode
> `<C-h/j/k/l>` navigation in `keymaps.nix` uses the same keys but a different mode.

---

## LSP (nvf defaults via nvim-lspconfig)

| Key | Action |
|-----|--------|
| `<leader>lgd` / `<leader>lgD` | Go to definition / declaration |
| `<leader>lgr` / `<leader>lgi` | References / implementations |
| `<leader>lh` | Hover |
| `<leader>ln` | Rename |
| `<leader>la` | Code action (cursor position) |
| `<leader>lA` | Code actions for the whole line (`:CodeActionLine`) |
| `<leader>lf` | Format |
| `<leader>lgn` / `<leader>lgp` | Next / previous diagnostic |
| `<leader>le` | Open diagnostic float |

> **nixd quirk**: nixd only returns a diagnostic's quickfix when the requested
> range overlaps the diagnostic's range. Neovim's `<leader>la` sends just the
> cursor position, so zero-width diagnostics like `expected ;` only offer a fix
> when the cursor is exactly on the offending character. Use `<leader>lA`
> (`:CodeActionLine`), jump with `<cr>` from Trouble, or select the line with
> `V` first.

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