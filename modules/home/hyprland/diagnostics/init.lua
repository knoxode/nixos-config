--- Central registry of diagnostic operations.
---
--- Single import point for hyprland.lua so debug options can be
--- selected without knowing which module defines them:
---
---   local Diagnostics = require("diagnostics")
---   Notify.configure({ debug = { Diagnostics.display_update_brightness } })
---
--- Keys must be unique and match the registered diagnostic names.

local events = require("events")
local display = require("systems.display")
local power_management = require("systems.powerManagement")
local brightness = require("helpers.brightness")
local monitors = require("helpers.monitors")
local workspaces = require("helpers.workspaces")
local power = require("helpers.power")
local sun = require("helpers.sun")

local M = {
  -- Event operations (whole events)
  startup = events.operations.startup,
  monitorChange = events.operations.monitorChange,
  powerChange = events.operations.powerChange,
  brightnessRefresh = events.operations.brightnessRefresh,

  -- Display
  display_configure = display.configure_display_environment,
  display_update_brightness = display.update_brightness,

  -- Brightness
  brightness_calculate = brightness.calculate,
  brightness_apply = brightness.apply,

  -- Monitors
  monitors_build_config = monitors.build_config,
  monitors_apply_config = monitors.apply_config,

  -- Workspaces
  workspaces_assign = workspaces.assign,

  -- Power
  power_is_on_AC = power.is_on_AC,
  powerprofile_configure = power_management.configure,

  -- Sun
  sun_get_effective_times = sun.GetEffectiveSunTimes,
}

return M
