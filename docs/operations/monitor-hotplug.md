# Monitor Hotplug Handling

**Source**: `modules/home/displayHotplugMonitor/`

---

## Scripts

| Script | Purpose |
|--------|---------|
| `displayHotplugMonitor.sh` | Main daemon — watches udev for monitor connect/disconnect |
| `handle_monitor_disconnect.sh` | Handles monitor disconnect (moves windows, updates workspaces) |
| `reconcileMonitors.sh` | Reconciles monitor state on startup/reconnect |

---

## Architecture

1. **udev rule** triggers `displayHotplugMonitor.sh` on `drm` subsystem changes
2. Daemon monitors `/run/udev` for monitor add/remove events
3. On event → calls `handle_monitor_disconnect.sh` or `reconcileMonitors.sh`
4. Scripts use `hyprctl` to:
   - Move windows to remaining monitors
   - Update workspace assignments
   - Reapply monitor rules (`hl.monitor`)

---

## Key Functions

### `reconcileMonitors.sh`
- Runs on startup and monitor reconnect
- Queries current monitors via `hyprctl monitors -j`
- Matches against configured rules in `hosts/<host>/variables.nix`
- Applies `hl.monitor` rules for each output

### `handle_monitor_disconnect.sh`
- Runs on monitor disconnect
- Identifies orphaned windows on disconnected output
- Moves them to primary/remaining monitor
- Preserves workspace layout where possible

---

## Configuration

Monitor rules defined in `hosts/<host>/variables.nix`:

```nix
{ ... }: {
  monitors = [
    { name = "eDP-1"; ... }
    { name = "HDMI-A-1"; ... }
  ];
}
```

---

## Debugging

```bash
# Run manually
displayHotplugMonitor.sh

# Check udev events
udevadm monitor --subsystem=drm

# Check hyprctl monitors
hyprctl monitors -j

# View logs
journalctl -u display-hotplug-monitor -f
```

---

## Known Issues

| Issue | Workaround |
|-------|------------|
| Race on rapid connect/disconnect | Daemon debounces 500ms |
| Windows not moving on disconnect | Check `hyprctl clients` for stuck windows |
| Workspace rules not reapplied | Run `reconcileMonitors.sh` manually |

---

## Related

- Hyprland monitor config: `modules/home/hyprland/layouts.lua`
- Workspace assignment: `modules/home/hyprland/helpers/workspaces.lua`
- Machine policy: `modules/home/hyprland/machine_specific/`