# Tmux Keybindings

**Source**: `modules/home/tmux/tmux.nix`  
**Prefix**: `C-Space` (Ctrl+Space)  
**Key mode**: vi

---

## Pane Navigation (no prefix)

| Key | Action |
|-----|--------|
| `ALT+Left` / `ALT+h` | Select pane left |
| `ALT+Right` / `ALT+l` | Select pane right |
| `ALT+Up` / `ALT+k` | Select pane up |
| `ALT+Down` / `ALT+j` | Select pane down |

---

## Window Navigation (no prefix)

| Key | Action |
|-----|--------|
| `SHIFT+Left` | Previous window |
| `SHIFT+Right` | Next window |
| `ALT+H` | Previous window (vim-style) |
| `ALT+L` | Next window (vim-style) |

---

## Pane Resize (with prefix)

| Key | Action |
|-----|--------|
| `C-Space` then `C-h` | Resize pane left 5 |
| `C-Space` then `C-j` | Resize pane down 5 |
| `C-Space` then `C-k` | Resize pane up 5 |
| `C-Space` then `C-l` | Resize pane right 5 |

---

## Vim-Tmux Navigator (with prefix)

| Key | Action |
|-----|--------|
| `C-Space` then `h` | Select pane left |
| `C-Space` then `j` | Select pane down |
| `C-Space` then `k` | Select pane up |
| `C-Space` then `l` | Select pane right |

> Seamless navigation between Vim and tmux panes.

---

## Base Settings

| Setting | Value |
|---------|-------|
| Base index | 1 (windows and panes) |
| Renumber windows | On |
| Escape time | 10ms |
| Focus events | On |
| Mouse | On |
| Default terminal | screen-256color |
| True color | Enabled |

---

## Plugins

- **vim-tmux-navigator** — Seamless Vim/tmux pane navigation
- **catppuccin** — Theme (mocha flavour)
- **tokyo-night-tmux** — Alternative theme

---

## Verification

```bash
# List all key bindings
tmux list-keys

# Show current prefix
tmux show-options -g prefix
```