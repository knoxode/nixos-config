# Hyprland Keybindings

**Source**: `modules/home/hyprland/binds.lua`  
**Modifier**: `SUPER` (Win key), `SUPER+SHIFT`, `ALT`, `CTRL+ALT`

---

## Window Focus & Movement

| Key | Action |
|-----|--------|
| `SUPER + h` | Focus window left |
| `SUPER + l` | Focus window right |
| `SUPER + j` | *Unbound* (scrolling layout doesn't support up/down) |
| `SUPER + k` | *Unbound* (scrolling layout doesn't support up/down) |

> **Note**: `SUPER+j/k` are explicitly unbound via `hl.unbind()` because Hyprland ships defaults for them but the `scrolling` layout doesn't support vertical focus — pressing them produced "layoutmsg doesn't exist" notifications.

---

## Window Management

| Key | Action |
|-----|--------|
| `SUPER + Return` | Open terminal (ghostty) |
| `SUPER + Q` | Close window |
| `SUPER + F` | Toggle fullscreen |
| `SUPER + P` | Toggle pseudo |
| `SUPER + ALT + Space` | Toggle floating |
| `SUPER + J` | Toggle split direction (dwindle layout only) |

---

## Column Resize (scrolling layout)

| Key | Action |
|-----|--------|
| `SUPER + SHIFT + h` | Column resize left (shrink) |
| `SUPER + SHIFT + l` | Column resize right (grow) |

---

## Workspaces

| Key | Action |
|-----|--------|
| `SUPER + 1-9,0` | Focus workspace 1-10 (via `helpers/workspaces.bind_focus`) |
| `SUPER + SHIFT + 1-9,0` | Move window to workspace 1-10 |
| `ALT + V` | Toggle special workspace "apps" |
| `SUPER + SHIFT + T` | Toggle special workspace "terminal" |

> With 2+ monitors: `SUPER+1-5` also switches secondary monitor to paired workspace (N+5).

---

## Screenshots

| Key | Action |
|-----|--------|
| `SUPER + SHIFT + S` | Region screenshot → clipboard (grim + slurp) |
| `SUPER + SHIFT + ALT + S` | Region screenshot → swappy editor |

---

## System

| Key | Action |
|-----|--------|
| `CTRL + ALT + Delete` | Open session panel (noctalia) |
| `SUPER + R` | Toggle launcher panel (noctalia) |
| `SUPER + E` | Open file manager (nautilus) |
| `SUPER + W` | Open Firefox Nightly |

---

## Media / Hardware (locked, repeating)

| Key | Action |
|-----|--------|
| `XF86AudioRaiseVolume` | Volume +5% |
| `XF86AudioLowerVolume` | Volume -5% |
| `XF86AudioMute` | Toggle mute |
| `XF86AudioMicMute` | Toggle mic mute |
| `XF86MonBrightnessUp` | Brightness +10% |
| `XF86MonBrightnessDown` | Brightness -10% |
| `XF86AudioNext/Prev/Play/Pause` | Playerctl media control |

---

## Mouse

| Key | Action |
|-----|--------|
| `SUPER + LMB` (mouse:272) | Drag window |
| `SUPER + RMB` (mouse:273) | Resize window |

---

## Verification

```bash
# List all active binds
hyprctl binds

# Check specific bind
hyprctl binds | grep "SUPER + h"
```