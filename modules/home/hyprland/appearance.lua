local shared = require("shared")

local last_on_battery = nil

--- Apply battery/AC appearance optimisations.
--- Disables blur and shadows on battery; enables them on AC.
---@param on_battery boolean
function apply_battery_optimisations(on_battery)
  if on_battery == last_on_battery then
    return
  end

  last_on_battery = on_battery

  if on_battery then
    hl.config({
      decoration = {
        blur = {
          enabled = false,
        },
        shadow = {
          enabled = false,
        },
      },
    })
  else
    hl.config({
      decoration = {
        shadow = {
          enabled = true,
          range = 28,
          render_power = 3,
          color = 0x890a0a0a,
        },
        blur = {
          enabled = true,

          brightness = 0.8,
          contrast = 2,
          noise = 0,
          vibrancy = 0.35,
          vibrancy_darkness = 0.5,

          passes = 2,
          size = 10,
          special = false,
        },
      },
    })
  end
end

-- Initial application will be handled by events module on startup
-- and via OnBatteryHook/OnACHook globals for power changes.

hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 11,

    border_size = 2,

    col = {
      active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
      inactive_border = "rgba(595959aa)",
    },

    -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
    resize_on_border = false,

    -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
    allow_tearing = false,

    layout = "dwindle",
  },

  decoration = {
    rounding = 20,
    rounding_power = 6,
  },

  animations = {
    enabled = true,
  },
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Default springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })
