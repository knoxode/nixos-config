# Hyprland Architecture

**Source**: `modules/home/hyprland/README.md`  
**Config format**: Lua (Hyprland 0.55+), deployed as out-of-store symlinks to `~/.config/hypr/`

---

## Module Layout

```
hyprland.lua            Entry point: requires, Notify setup, machine hook, render quirks
workspaces.lua          Static workspace rules (special workspaces)
exec.lua                Autostart / shutdown
appearance.lua          Visual config (borders, gaps, rounding, ...)
animations.lua          Animation config
binds.lua               Key bindings
env.lua                 Environment variables
gpu.lua                 GPU-related config
layouts.lua             Tiling layout config
misc.lua                Misc options
permissions.lua         Permission rules
windowrules.lua         Window rules
shared.lua              Shared constants (mainMod, terminal, ...)

events/                 Event operations: startup, monitorChange, powerChange, brightnessRefresh
systems/                Behavioural subsystems (display, powerManagement)
helpers/                Reusable functions (monitors, workspaces, brightness, sun, power, system, notify)
machine_specific/       Per-host overrides and policy table
diagnostics/            Flat registry of debug options for hyprland.lua
```

---

## Generated Files

| File | Source | Notes |
|------|--------|-------|
| `host.lua` | `hosts/<host>/default.nix` (`alexos.host.hyprland`) | Hostname, sun coordinates, keyboard layouts |
| `devices.lua` | `hosts/<host>/default.nix` (`alexos.host.hyprland`) | Input device assignments |

> **Edit the host's `alexos.host.hyprland` and rebuild** to change these — they are store paths, not repo symlinks.

---

## Execution Model

- **Top-level code** in every module runs on each config load **and reload**. Keep it declarative: `hl.config`, `hl.monitor`, rules, `hl.on`.
- **Event handlers** live in `events/init.lua`, which orchestrates `systems/` and `helpers/` operations. Handlers run inside `Notify.scope()` (captures errors: log + one notification).
- **Subprocesses** (`io.popen`) block the compositor's config thread. Keep them short; network calls are cached/backed off (see `helpers/sun.lua`).

---

## Machine Policy

`machine_specific/init.lua` selects a per-host module by hostname. Policies in `machine_specific/<host>/init.lua`:

| Policy | Meaning |
|--------|---------|
| `dynamic_monitors` | Recompute monitor modes/positions on events (generic machines) |
| `automatic_brightness` | Adjust brightness on events and 30-minute timer |
| `primary_desc` | Description prefix of monitor getting workspaces 1-5 (nil = first non-eDP-1) |

**Node** (2 monitors): Uses static `desc:`-based `hl.monitor` rules. Empty-output fallback covers unexpected states.

**Workspace assignment**: Single source in `helpers/workspaces.lua`, runs on startup and monitor change. `$mainMod+number` focus binds registered there (`bind_focus`): with 2+ monitors, keys 1-5 also switch secondary monitor to paired workspace (N+5).

---

## Diagnostics

### Knobs (in `hyprland.lua`)

```lua
Notify.configure({
  debug = { Diagnostics.display_update_brightness },  -- any number of options
})
```

`diagnostics/init.lua` = single registry of debug options. Keys range from whole events (`monitorChange`) to individual helpers (`brightness.apply`). Debug enabled if any enabled function is on active call stack.

### Sinks

| Channel | Where | When |
|---------|-------|------|
| DEBUG | `~/.local/state/hypr/alexos.log` | Only when enabled via `debug` |
| INFO | Log + notification | Always (meaningful conditions) |
| ERROR | Log (with traceback) + short "see alexos.log" notification | Always, from `Notify.scope` |

```bash
# Follow debug log
tail -f ~/.local/state/hypr/alexos.log
```

### Adding a Diagnostic Unit

1. In owning module: `Notify.register({ ["unit.name"] = M.fn })`
2. Add unique key to `diagnostics/init.lua`
3. Nothing else — `debug()` finds it via call stack

---

## API Notes

- Monitor rule fields (`mode`, `cm`, `supports_hdr`, `sdrbrightness`, `sdr_min_luminance`, `desc:` output matching, empty-output fallback) → <https://wiki.hypr.land/configuring/core/monitors/>
- Event names (`monitor.added`, `monitor.removed`, `config.reloaded`, `hyprland.start`, `hyprland.shutdown`, ...) → <https://wiki.hypr.land/configuring/core/advanced-configuration/events/>
- **Lua API reference** (not fully documented on wiki): <https://alejandrominaya.github.io/hyprland-lua-docs/>
- **Not fully documented upstream** (verify at runtime):
  - Exact `HL.Monitor` fields from `hl.get_monitors()` and ordering
  - Whether `hl.monitor` resets omitted fields to defaults (we always pass explicit modes)
  - `hl.exec_cmd` failure reporting