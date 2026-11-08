# Ghostty Keybindings

**Source**: `modules/home/ghostty.nix`  
**Modifiers**: `CTRL+SHIFT`, `CTRL+ALT`, `ALT+SHIFT`

---

## Split Navigation (vim-style)

| Key | Action |
|-----|--------|
| `CTRL+SHIFT + h` | Go to split left (`goto_split:left`) |
| `CTRL+SHIFT + j` | Go to split bottom (`goto_split:bottom`) |
| `CTRL+SHIFT + k` | Go to split top (`goto_split:top`) |
| `CTRL+SHIFT + l` | Go to split right (`goto_split:right`) |

> Uses Ghostty 1.2+ **spatial navigation** — finds nearest split in direction from top-left of current split.

---

## Split Creation

| Key | Action |
|-----|--------|
| `CTRL+ALT + v` | New split right (`new_split:right`) |
| `CTRL+ALT + s` | New split down (`new_split:down`) |

---

## Split Resize

| Key | Action |
|-----|--------|
| `CTRL+ALT + h` | Resize split left 20 cells (`resize_split:left,20`) |
| `CTRL+ALT + j` | Resize split down 20 cells (`resize_split:down,20`) |
| `CTRL+ALT + k` | Resize split up 20 cells (`resize_split:up,20`) |
| `CTRL+ALT + l` | Resize split right 20 cells (`resize_split:right,20`) |

---

## Tabs

| Key | Action |
|-----|--------|
| `CTRL+SHIFT + t` | New tab (`new_tab`) |
| `CTRL+Q` | Close tab (`close_tab`) |
| `CTRL+SHIFT + b` | Move tab to position -1 (`move_tab:-1`) |
| `CTRL+N` | Prompt tab title (`prompt_tab_title`) |

---

## Scrollback / Selection

| Key | Action |
|-----|--------|
| `ALT+SHIFT + h` | Adjust selection left (`adjust_selection:left`) |
| `ALT+SHIFT + j` | Adjust selection down (`adjust_selection:down`) |
| `ALT+SHIFT + k` | Adjust selection up (`adjust_selection:up`) |
| `ALT+SHIFT + l` | Adjust selection right (`adjust_selection:right`) |
| `CTRL+[` | Scroll page up (`scroll_page_up`) |
| `CTRL+]` | Scroll page down (`scroll_page_down`) |

---

## Search

| Key | Action |
|-----|--------|
| `CTRL+SHIFT + f` | Start search (`start_search`) |
| `ALT+N` | Next match (`navigate_search:next`) |
| `ALT+SHIFT + N` | Previous match (`navigate_search:previous`) |

---

## Quick Terminal

| Key | Action |
|-----|--------|
| `CTRL+SHIFT + q` | Toggle quick terminal (`toggle_quick_terminal`) |

---

## Explicitly Unbound (Ghostty defaults)

| Default Key | Action | Reason |
|-------------|--------|--------|
| `CTRL+SHIFT+O` | New split right | Replaced by `CTRL+ALT+v` |
| `CTRL+SHIFT+E` | New split down | Replaced by `CTRL+ALT+s` |
| `CTRL+ALT+Arrow` | Split navigation | Replaced by `CTRL+SHIFT+h/j/k/l` |
| `CTRL+SHIFT+F` | Start search | Explicitly bound to `start_search` |
| `CTRL+SHIFT+W` | Close surface | Using `CTRL+Q` for close tab |

---

## Verification

```bash
# List all active keybinds
ghostty +list-keybinds

# List default keybinds
ghostty +list-keybinds --default
```