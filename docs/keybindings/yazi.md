# Yazi Keybindings

**Source**: `modules/home/yazi/keymap.nix`

---

## Manager (file browser)

| Key | Action | Description |
|-----|--------|-------------|
| `z` | `plugin zoxide` | Jump to directory via zoxide |
| `Z` | `plugin fzf` | Jump to file/directory via fzf |
| `t` | `tab_create --current` | Create new tab with CWD |
| `g i` | `plugin lazygit` | Run lazygit in current directory |
| `l` | `plugin smart-enter` | Enter child directory or open file |

---

## Help

| Key | Action | Description |
|-----|--------|-------------|
| `f` | `filter` | Filter help items |

---

## Notes

- Uses `prepend_keymap` — adds to defaults, doesn't replace
- `g i` is a chord: press `g` then `i`
- Plugins: zoxide, fzf, lazygit, smart-enter

---

## Verification

```bash
# In yazi, press F1 for help
# Or check config at ~/.config/yazi/keymap.toml
```