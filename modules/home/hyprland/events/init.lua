local display = require("systems.display")
local power = require("systems.powerManagement")
local power_helper = require("helpers.power")
local workspace_helpers = require("helpers.workspaces")
local machine = require("machine_specific")
local Notify = require("helpers.notify")

local M = {}

--- Public event operations also serve as diagnostic identifiers.
--- Notify.register() discovers these functions automatically, allowing
--- them to be selected for debugging without a separate operation registry.
---
--- Declaring this table separately also improves LuaLS field inference.
M.operations = {}

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

function M.operations.monitorChange()
  local ctx = make_context()

  workspace_helpers.assign(ctx.monitors, machine.policy)

  if machine.policy.dynamic_monitors then
    display.configure_display_environment(ctx)
  end

  if machine.policy.automatic_brightness then
    display.update_brightness(ctx)
  end
end

function M.operations.powerChange(on_AC)
  local ctx = make_context(on_AC)

  workspace_helpers.assign(ctx.monitors, machine.policy)
  display.configure_display_environment(ctx)
  display.update_brightness(ctx)
  power.configure(ctx)
end

function M.operations.brightnessRefresh()
  local ctx = make_context()
  display.update_brightness(ctx)
end

function M.operations.startup()
  local ctx = make_context()

  workspace_helpers.assign(ctx.monitors, machine.policy)
  display.configure_display_environment(ctx)
  display.update_brightness(ctx)
  power.configure(ctx)

  -- Timers execute independently of the startup operation, so each
  -- brightness refresh needs its own diagnostic scope.
  hl.timer(function()
    local ok, err = pcall(function()
      Notify.scope(M.operations.brightnessRefresh)
    end)

    if not ok then
      Notify.info("Brightness error: " .. tostring(err))
    end
  end, {
    timeout = 30 * 60 * 1000,
    type = "repeat",
  })
end

--- Each event handler runs through Notify.scope() to establish a diagnostic
--- context for the entire operation, including any helpers it calls.
---
--- The root operation determines whether debug messages are enabled.
--- Nested function calls inherit this setting automatically, so helpers
--- can call Notify.debug() without knowing which event triggered them.
---
--- Calling an operation directly would bypass this diagnostic context.

function M.register()
  hl.on("hyprland.start", function()
    Notify.scope(M.operations.startup)
  end)

  hl.on("monitor.added", function()
    Notify.scope(M.operations.monitorChange)
  end)

  hl.on("monitor.removed", function()
    Notify.scope(M.operations.monitorChange)
  end)

  hl.on("config.reloaded", function()
    Notify.scope(M.operations.monitorChange)
  end)
end

-- Exposed globally for Noctalia integration.
function OnBatteryHook()
  Notify.scope(M.operations.powerChange, false)
end

function OnACHook()
  Notify.scope(M.operations.powerChange, true)
end

return M
