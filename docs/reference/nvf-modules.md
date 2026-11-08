# nvf Modules Enabled

**Source of truth**: `modules/home/nvf/vim/*.nix`

**Snapshot**: module list, updated manually — for lookup, not daily use.

**Framework**: nvf (Neovim on Nix) + mnw wrapper

---

## Core Settings (`entry.nix`)

| Option | Value |
|--------|-------|
| `enable` | `true` |
| `vimAlias` | `true` |
| `viAlias` | `true` |
| `withNodeJs` | `true` |
| `lineNumberMode` | `relNumber` |
| `enableLuaLoader` | `true` |
| `preventJunkFiles` | `true` |
| `tabstop` | `4` |
| `shiftwidth` | `2` |
| `wrap` | `false` |

---

## Enabled Modules

| Module | File | Status |
|--------|------|--------|
| **Binds** | `binds.nix` | ✅ which-key + cheatsheet |
| **Keymaps** | `keymaps.nix` | ✅ Custom mappings |
| **Telescope** | `telescope.nix` | ✅ |
| **Neotree** | `neotree.nix` | ✅ File tree |
| **Dashboard** | `dashboard.nix` | ✅ Start screen |
| **Theme** | `theme.nix` | ✅ |
| **ToggleTerm** | `toggleterm.nix` | ✅ Float terminal + lazygit |
| **Minimap** | `minimap.nix` | ✅ |
| **Notes** | `notes.nix` | ✅ Obsidian (conditional) |
| **Auto Actions** | `autoActions.nix` | ✅ |
| **Diagnostics** | `diagnostics.nix` | ✅ |
| **Notify** | `notify.nix` | ✅ |
| **Treesitter** | `treesitter.nix` | ✅ |
| **UI** | `ui.nix` | ✅ |
| **Visuals** | `visuals.nix` | ✅ |
| **Projects** | `projects.nix` | ✅ |
| **Git** | `git.nix` | ✅ |
| **Snippets** | `snippets.nix` | ✅ |
| **Utilities** | `utility.nix` | ✅ |
| **Assistants** | `assistants/main.nix` | ✅ CodeCompanion |
| **Languages** | `languages.nix` | ✅ Multi-language |
| **Clipboard** | `clipboard.nix` | ✅ |
| **Harper Spell** | `harperSpellCheck.nix` | ✅ |
| **Statusline** | `statusline.nix` | ✅ |
| **Formatter** | `formatter.nix` | ✅ |
| **Extended Nixd** | `extendedNixdOpts.nix` | ✅ Nix LSP options |
| **R Settings** | `rSpecificSettings.nix` | ✅ R language |

---

## Notable Module Details

### `binds.nix`
```nix
vim.binds = {
  whichKey.enable = true;
  cheatsheet.enable = true;
};
```

### `toggleterm.nix`
```nix
vim.terminal.toggleterm = {
  enable = true;
  direction = "float";
  lazygit.enable = true;
};
```

### `notes.nix` (Obsidian)
Conditional on `username == "shaiikura"`:
- Workspace: `/home/shaiikura/Documents/syncthing/obsidian/second_brain/`
- Picker: telescope
- Completion: blink.cmp

### `keymaps.nix` Custom Mappings
- `jk` → Escape (insert)
- `<leader>e` → Neotree toggle
- `<leader>ff/lg/fe` → Telescope
- `<C-h/j/k/l>` → Arrow keys (insert)
- `<leader>dj/dk/dl/dt` → Diagnostics
- `<leader>oo/off/ofg/on/ob/ot/opi` → Obsidian

---

## Upstream References

- nvf options: <https://nvf.notashelf.dev/options.html>
- nvf manual: <https://nvf.notashelf.dev/>
- nvf GitHub: <https://github.com/NotAShelf/nvf>