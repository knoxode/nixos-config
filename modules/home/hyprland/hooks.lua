local shared = require("shared")
---
---@param on_AC boolean
function SetGraphicsOpts(on_AC)
  if not on_AC then
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
        blur = {
          enabled = true,
          size = 3,
          passes = 1,
          vibrancy = 0.1696,
        },
        shadow = {
          enabled = true,
          range = 4,
          render_power = 3,
          color = "0xee1a1a1a",
        },
      },
    })
  end
end

function OnBatteryHook()
  shared.on_AC = false

  SetGraphicsOpts(shared.on_AC)

  Notify.debug("Switched to battery. Performing Battery Optimisations.")
  shared.SetPowerSettings(shared.on_AC)
end

function OnACHook()
  shared.on_AC = true

  SetGraphicsOpts(shared.on_AC)

  Notify.debug("Switched to AC. Enabling Fancy Graphics.")
  shared.SetPowerSettings(shared.on_AC)
end
