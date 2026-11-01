# Cross-Layer Keybinding Conflicts

**Last updated**: 2026-11-01  
**Generated from**: `modules/home/hyprland/binds.lua`, `modules/home/ghostty.nix`, `modules/home/nvf/vim/keymaps.nix`, `modules/home/tmux/tmux.nix`, `modules/home/yazi/keymap.nix`, `modules/home/noctalia/main.nix`

---

## Conflict Summary

| Keys | Layers | Severity | Status |
|------|--------|----------|--------|
| `CTRL+h/j/k/l` | Ghostty vs Neovim (smart-splits) | **High** | Mitigated by modifier difference |
| `ALT+h/j/k/l` | Ghostty vs Neovim (smart-splits) | Low | Ghostty unbound |
| `SUPER+j/k` | Hyprland defaults vs scrolling layout | **Fixed** | Explicitly unbound |
| `CTRL+SHIFT+f` | Ghostty (search + move_tab) | Medium | Dual-bound, last wins |

---

## Detailed Analysis

### 1. `CTRL+h/j/k/l` — Ghostty vs Neovim smart-splits

| Layer | Binding | Action |
|-------|---------|--------|
| **Ghostty** | `CTRL+SHIFT+h/j/k/l` | `goto_split` (navigate terminal splits) |
| **Neovim** (smart-splits) | `CTRL+h/j/k/l` | `move_cursor` (navigate Neovim splits) |

**Resolution**: Different modifiers — Ghostty requires `SHIFT`, Neovim doesn't. Ghostty captures `CTRL+SHIFT` at terminal layer; Neovim only sees `CTRL` when Ghostty isn't focused (e.g., SSH, non-Ghostty terminal).

**Risk**: If smart-splits is enabled in nvf, `CTRL+h/j/k/l` in Neovim **will not work** inside Ghostty — Ghostty intercepts them first.

**Recommendation**: 
- Keep Ghostty on `CTRL+SHIFT` for terminal splits
- If using smart-splits in Neovim, either disable its `move_cursor` binds or accept they only work outside Ghostty

---

### 2. `ALT+h/j/k/l` — Ghostty vs Neovim smart-splits

| Layer | Binding | Action |
|-------|---------|--------|
| **Ghostty** | Unbound (arrows unbound) | — |
| **Neovim** (smart-splits) | `ALT+h/j/k/l` | `resize_split` |

**Resolution**: No conflict — Ghostty explicitly unbound `CTRL+ALT+arrows`, and `ALT+h/j/k/l` was never bound.

**Risk**: Only if you add `ALT+arrows` or `ALT+h/j/k/l` to Ghostty config.

---

### 3. `SUPER+j/k` — Hyprland defaults vs scrolling layout

| Layer | Binding | Issue |
|-------|---------|-------|
| **Hyprland defaults** | `SUPER+j/k` | Focus up/down |
| **scrolling layout** | — | Doesn't support vertical focus |

**Symptom**: "layoutmsg doesn't exist" notifications when pressing `SUPER+j/k`

**Resolution**: Explicitly unbound in `binds.lua`:
```lua
hl.unbind("SUPER + j")
hl.unbind("SUPER + k")
```

**Status**: ✅ Fixed

---

### 4. `CTRL+SHIFT+f` — Ghostty dual binding

| Binding | Action | Note |
|---------|--------|------|
| `CTRL+SHIFT+f` | `move_tab:1` | First in keybind array |
| `CTRL+SHIFT+f` | `start_search` | Later in array, **wins** |

**Resolution**: Last bind wins in Ghostty. `start_search` is the effective action.

**Recommendation**: Remove the `move_tab:1` bind or use a different key.

---

## Layer Separation Summary

| Layer | Primary Modifiers | Scope |
|-------|-------------------|-------|
| **Hyprland** | `SUPER`, `SUPER+SHIFT`, `ALT` | Global (WM) |
| **Ghostty** | `CTRL+SHIFT`, `CTRL+ALT`, `ALT+SHIFT` | Terminal only |
| **Neovim** | `<leader>` (SPACE), `CTRL`, `ALT` | Editor only |
| **Tmux** | `C-Space` (prefix), `ALT`, `CTRL` | Multiplexer only |
| **Yazi** | Single keys, `g` prefix | File manager only |
| **Noctalia** | Arrows, `Escape`, `Return`, digits | Panel/shell only |

**Key insight**: Modifiers are mostly distinct per layer. Conflicts only arise when:
1. Same modifier + key used in parent/child (Ghostty → Neovim)
2. System defaults leak through (Hyprland `SUPER+j/k`)

---

## Maintenance Checklist

When modifying keybindings:

1. **Check this file** for existing conflicts
2. **Verify current bindings** in each config:
   - `modules/home/hyprland/binds.lua`
   - `modules/home/ghostty.nix`
   - `modules/home/nvf/vim/keymaps.nix`
   - `modules/home/tmux/tmux.nix`
   - `modules/home/yazi/keymap.nix`
   - `modules/home/noctalia/main.nix`
3. **Test at runtime**:
   ```bash
   ghostty +list-keybinds
   hyprctl binds
   # In Neovim: :map
   ```
4. **Check upstream docs** for new/changed options:
   - Hyprland: <https://wiki.hypr.land>
   - Ghostty: <https://ghostty.org/docs/config/reference>
   - nvf: <https://nvf.notashelf.dev/options.html>
   - nixpkgs: <https://search.nixos.org/options>
5. **Update this file** if conflicts change

---

## Verification Commands

```bash
# All Ghostty binds
ghostty +list-keybinds

# All Hyprland binds
hyprctl binds

# Neovim leader + maps
# In nvim: :echo mapleader | :map

# Tmux binds
tmux list-keys
```