-- helpers/workspaces.lua

local Notify = require("helpers.notify")
local shared = require("shared")

local M = {}

--- Choose the primary monitor for workspace assignment.
---
--- Preference order:
---   1. Description prefix from the machine policy (if set).
---   2. First monitor that is not eDP-1 (laptop external display).
---   3. First monitor.
---
---@param monitors HL.Monitor[]
---@param policy table
---@return HL.Monitor
local function choose_primary(monitors, policy)
  if policy and policy.primary_desc then
    for _, monitor in ipairs(monitors) do
      if monitor.description and monitor.description:sub(1, #policy.primary_desc) == policy.primary_desc then
        return monitor
      end
    end
  end

  for _, monitor in ipairs(monitors) do
    if monitor.name ~= "eDP-1" then
      return monitor
    end
  end

  return monitors[1]
end

--- Assign numbered workspaces to monitors.
---
--- One monitor: all workspaces on it.
--- Two or more: workspaces 1-5 on the primary, 6-10 on the first
--- remaining monitor.
---
---@param monitors HL.Monitor[]
---@param policy table
function M.assign(monitors, policy)
  if #monitors == 0 then
    return
  end

  if #monitors == 1 then
    for i = 1, 10 do
      hl.workspace_rule({
        workspace = tostring(i),
        monitor = monitors[1].name,
      })
    end

    return
  end

  local primary = choose_primary(monitors, policy)

  local secondary = nil
  for _, monitor in ipairs(monitors) do
    if monitor ~= primary then
      secondary = monitor
      break
    end
  end

  if not secondary then
    return
  end

  for i = 1, 5 do
    hl.workspace_rule({
      workspace = tostring(i),
      monitor = primary.name,
    })
    hl.workspace_rule({
      workspace = tostring(i + 5),
      monitor = secondary.name,
    })
  end
end

--- Bind the $mainMod+number focus binds for the current monitor setup.
---
--- One monitor: key N focuses workspace N.
--- Two or more: keys 1-5 first focus the paired workspace N+5, so the
--- secondary monitor switches in lockstep with the primary, then focus
--- N. Keys 6-10 focus the secondary's workspaces only. Calling again
--- on a monitor event replaces the previous binds.
---
---@param monitors HL.Monitor[]
function M.bind_focus(monitors)
  local paired = #monitors >= 2

  for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0

    if paired and i <= 5 then
      hl.bind(shared.mainMod .. " + " .. key, hl.dsp.focus({ workspace = i + 5 }))
    end
    hl.bind(shared.mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  end
end

Notify.register({
  ["workspaces.assign"] = M.assign,
  ["workspaces.bind_focus"] = M.bind_focus,
})

return M
