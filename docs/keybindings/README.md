# Keybindings

Unified reference for all keybindings across the system layers.

## Layers

| Layer | Scope | Modifier | Doc |
|-------|-------|----------|-----|
| **Hyprland** | Window manager (global) | `SUPER`, `SUPER+SHIFT`, `ALT` | [hyprland.md](hyprland.md) |
| **Ghostty** | Terminal emulator | `CTRL+SHIFT`, `CTRL+ALT`, `ALT+SHIFT` | [ghostty.md](ghostty.md) |
| **Neovim** | Editor | `<leader>` (SPACE), `CTRL`, `ALT` | [neovim.md](neovim.md) |
| **Tmux** | Terminal multiplexer | `C-Space` (prefix), `ALT`, `CTRL` | [tmux.md](tmux.md) |
| **Yazi** | File manager | Single keys, `g` prefix | [yazi.md](yazi.md) |
| **Noctalia** | Shell/panel | Arrows, `Escape`, `Return`, digits | [noctalia.md](noctalia.md) |

## Cross-Layer Conflicts

See [conflicts.md](conflicts.md) for known overlaps and resolutions.

## Quick Reference

```bash
# List Ghostty binds
ghostty +list-keybinds

# List Hyprland binds
hyprctl binds

# Check Neovim leader
:echo mapleader
```