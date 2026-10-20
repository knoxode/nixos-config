local display = require("systems.display")
local power = require("systems.powerManagement")
local power_helper = require("helpers.power")
local machine = require("machine_specific")

local M = {}

local function make_context(on_AC)
  if on_AC == nil then
    on_AC = power_helper.is_on_AC()
  end

  -- Default to AC behaviour when no battery state is available
  if on_AC == nil then
    on_AC = true
  end

  return {
    monitors = hl.get_monitors(),
    on_AC = on_AC,
  }
end

local function refresh_display_configuration()
  local ctx = make_context()

  if machine.policy.dynamic_monitors then
    display.configure_display_environment(ctx)
  end

  if machine.policy.automatic_brightness then
    display.update_brightness(ctx)
  end
end

local function handle_power_change(on_AC)
  local ctx = make_context(on_AC)

  display.configure_display_environment(ctx)
  display.update_brightness(ctx)
  power.configure(ctx)
end

local function refresh_brightness()
  hl.notification.create({
    text = "Brightness callback triggered",
    timeout = 5000,
  })

  local ok, err = pcall(function()
    local ctx = make_context()
    display.update_brightness(ctx)
  end)

  if not ok then
    hl.notification.create({
      text = "Brightness error: " .. tostring(err),
      timeout = 10000,
    })
  end
end

function M.register()
  hl.on("hyprland.start", function()
    local ctx = make_context()

    display.configure_display_environment(ctx)
    display.update_brightness(ctx)
    power.configure(ctx)

    hl.timer(refresh_brightness, {
      timeout = 30 * 60 * 1000,
      type = "repeat",
    })
  end)

  hl.on("monitor.added", refresh_display_configuration)
  hl.on("monitor.removed", refresh_display_configuration)
  hl.on("config.reloaded", refresh_display_configuration)
end

-- Exposed globally for your existing Noctalia integration.
function OnBatteryHook()
  handle_power_change(false)
end

function OnACHook()
  handle_power_change(true)
end

return M
