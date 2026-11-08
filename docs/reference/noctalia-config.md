# Noctalia Config Reference

**Source of truth**: `modules/home/noctalia/main.nix`

**Snapshot**: full settings dump, updated manually — for lookup, not daily use.

---

## Keybinds

```nix
keybinds = {
  cancel = [ "Escape" ];
  down = [ "Down" ];
  left = [ "Left" ];
  right = [ "Right" ];
  up = [ "Up" ];
  validate = [ "Return" "KP_Enter" ];
};
```

---

## Session Actions (Lockscreen)

```nix
session.actions = [
  { action = "lock";              shortcut = "1"; variant = "default"; }
  { action = "logout";            shortcut = "2"; variant = "default"; }
  { action = "lock_and_suspend";  shortcut = "3"; variant = "default"; }
  { action = "reboot";            shortcut = "4"; variant = "default"; }
  { action = "shutdown";          shortcut = "5"; variant = "destructive"; }
];
```

---

## Control Center Shortcuts

```nix
control_center.shortcuts = [
  { type = "wifi" }
  { type = "bluetooth" }
  { type = "caffeine" }
  { type = "nightlight" }
  { type = "notification" }
  { type = "power_profile" }
];
```

---

## OSD Kinds

```nix
osd.kinds = {
  bluetooth = true;
  brightness = true;
  caffeine = true;
  dnd = true;
  keyboard_layout = true;
  lock_keys = true;
  media = true;
  nightlight = true;
  power_profile = true;
  privacy = true;
  volume = true;
  volume_input = true;
  volume_output = true;
  wifi = true;
};
```

---

## Bar Configuration

```nix
bar = {
  position = "top";
  layer = "top";
  thickness = 41;
  radius = 25;
  background_opacity = 0.5;
  border = "hover";
  border_width = 0.5;
  auto_hide = false;
  center = [ "group:g2" ];
  start = [ "group:g5" "group:g1" ];
  end = [ "tray" "notifications" "group:g4" "group:g3" "session" "clock" ];
  widget_spacing = 18;
  padding = 14;
  scale = 1.1;
  capsule = false;
  shadow = true;
  # Groups g1-g5 defined with various widgets
};
```

---

## Idle Behavior

```nix
idle = {
  behavior_order = [ "lock" "screen-off" "suspend" ];
  pre_action_fade_seconds = 2.0;
  behavior = {
    "screen-off" = { action = "screen_off"; timeout = 60; };
    lock = { action = "lock"; timeout = 300; };
    suspend = { action = "suspend"; enabled = (hostType != "Desktop"); timeout = 600; };
  };
};
```

---

## Wallpaper

```nix
wallpaper = {
  directory = "/home/${username}/Pictures/DesktopBackground";
  enabled = true;
  fill_mode = "crop";
  edge_smoothness = 0.3;
  transition = [ "disc" ];
  transition_duration = 1500;
  automation = { enabled = true; interval_seconds = 180; order = "random"; };
};
```

---

## Theme

```nix
theme = {
  builtin = "Noctalia";
  community_palette = "Oxocarbon";
  mode = "dark";
  source = "wallpaper";
  wallpaper_scheme = "m3-fruit-salad";
  templates = {
    builtin_ids = [ "ghostty" ];
    enable_builtin_templates = true;
    enable_community_templates = true;
  };
};
```

---

## Shell

```nix
shell = {
  font_family = "Roboto Flex";
  date_format = "%A, %x";
  time_format = "{:%H:%M}";
  clipboard_enabled = true;
  clipboard_history_max_entries = 100;
  settings_show_advanced = true;
  animation = { enabled = true; speed = 1.0; };
  panel = {
    transparency_mode = "glass";
    launcher_placement = "floating";
    control_center_placement = "attached";
  };
};
```

---

## System Monitor

```nix
system.monitor = {
  enabled = true;
  cpu_poll_seconds = 2.0;
  memory_poll_seconds = 2.0;
  network_poll_seconds = 3.0;
  cpu_temp_critical_threshold = 85.0;
  cpu_usage_critical_threshold = 90.0;
  gpu_temp_critical_threshold = 85.0;
  gpu_usage_critical_threshold = 95.0;
  ram_pct_critical_threshold = 90.0;
};
```

---

## Upstream Reference

- Noctalia config docs: Check `noctalia --help` or GitHub repo
- Config file: `~/.config/noctalia/config.toml` (generated from Nix)