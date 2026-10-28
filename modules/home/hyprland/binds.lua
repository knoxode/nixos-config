local shared = require("shared")

-- Switching workspaces
--
-- The $mainMod+number focus binds are registered by
-- helpers/workspaces.bind_focus, keyed to the current monitor setup:
-- with two or more monitors, keys 1-5 also switch the secondary
-- monitor to the paired workspace (N+5), so both change together.
-- The SHIFT binds below stay static. Key 0 selects workspace 10.

for i = 1, 10 do
  local key = i % 10
  hl.bind(shared.mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

hl.bind(shared.mainMod .. " + Return", hl.dsp.exec_cmd(shared.terminal))
local closeWindowBind = hl.bind(shared.mainMod .. " + Q", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
hl.bind(shared.mainMod .. " + R", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
hl.bind(shared.mainMod .. " + E", hl.dsp.exec_cmd(shared.fileManager))
hl.bind(shared.mainMod .. " + W", hl.dsp.exec_cmd("firefox-nightly"))
hl.bind(shared.mainMod .. " + ALT + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(shared.mainMod .. " + SHIFT + S", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy'))
hl.bind(
  shared.mainMod .. " + SHIFT + ALT + S",
  hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f - # Screen snip >> edit')
)
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("noctalia msg panel-open session"))
hl.bind(shared.mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(shared.mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(shared.mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only

-- Move focus with shared.mainMod + arrow keys
hl.bind("CTRL + SHIFT + h", hl.dsp.focus({ direction = "left" }), { repeating = true })

hl.bind("CTRL + SHIFT + l", hl.dsp.focus({ direction = "right" }), { repeating = true })

hl.bind("CTRL + SHIFT + k", hl.dsp.focus({ direction = "up" }), { repeating = true })

hl.bind("CTRL + SHIFT + j", hl.dsp.focus({ direction = "down" }), { repeating = true })

hl.bind("SPACE + h", hl.dsp.layout("colresize -0.05"), { repeating = true })

hl.bind("SPACE + l", hl.dsp.layout("colresize +0.05"), { repeating = true })

-- Move/resize windows with shared.mainMod + LMB/RMB and dragging
hl.bind(shared.mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(shared.mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

--Special workspace
hl.bind("ALT + V", hl.dsp.workspace.toggle_special("apps"))
hl.bind("SUPER + SHIFT + T", hl.dsp.workspace.toggle_special("terminal"))

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
  "XF86AudioRaiseVolume",
  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioLowerVolume",
  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMicMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up 10"), { locked = true, repeating = true })
hl.bind(
  "XF86MonBrightnessDown",
  hl.dsp.exec_cmd("noctalia msg brightness-down 10"),
  { locked = true, repeating = true }
)

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
