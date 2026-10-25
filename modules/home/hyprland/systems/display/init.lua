local Notify = require("helpers.notify")
local monitor_helpers = require("helpers.monitors")
local brightness_helper = require("helpers.brightness")

local M = {}

---@param monitors HL.Monitor[]
---@param on_AC boolean
local function apply_monitor_settings(monitors, on_AC)
  local max_refresh_rate = on_AC and math.huge or 60.01

  for _, monitor in ipairs(monitors) do
    local config = monitor_helpers.build_config(monitor, #monitors, max_refresh_rate)

    if config then
      monitor_helpers.apply_config(config)
    end
  end
end

---@param ctx table
function M.configure_display_environment(ctx)
  local monitors = ctx.monitors

  if #monitors == 0 or #monitors > 2 then
    return
  end

  Notify.debug(string.format("Configuring %d monitors", #monitors))

  apply_monitor_settings(monitors, ctx.on_AC)
end

function M.update_brightness(ctx)
  local brightness = brightness_helper.calculate(ctx.on_AC)

  Notify.debug(
    string.format("Display: Updating brightness to %d%% | Power: %s", brightness, ctx.on_AC and "AC" or "Battery")
  )

  brightness_helper.apply(brightness)
end

Notify.register({
  ["display.configure_display_environment"] = M.configure_display_environment,
  ["display.update_brightness"] = M.update_brightness,
})

return M
