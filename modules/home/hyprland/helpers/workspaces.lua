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

  local repair = policy and policy.repair_stale == true

  if #monitors == 1 then
    for i = 1, 10 do
      hl.workspace_rule({
        workspace = tostring(i),
        monitor = monitors[1].name,
        default = repair and i == 1,
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
      default = repair and i == 1,
    })
    hl.workspace_rule({
      workspace = tostring(i + 5),
      monitor = secondary.name,
      default = repair and i == 1,
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

--- A monitor can come up on an empty workspace outside its configured range
--- (for example workspace 11 on the secondary, before the default rules take
--- effect). Move those monitors back to their default without disturbing a
--- monitor that is already on a valid workspace.
---
---@param monitors HL.Monitor[]
---@param policy table
function M.repair_stale(monitors, policy)
  if #monitors == 0 or not (policy and policy.repair_stale == true) then
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

  local focused = nil
  for _, monitor in ipairs(monitors) do
    if monitor.focused then
      focused = monitor
      break
    end
  end

  local repairs = {}
  local function add_repair(monitor, default, lo, hi)
    local workspace = monitor.active_workspace
    local name = workspace and workspace.name or ""
    local number = tonumber(name)
    local valid = number and number >= lo and number <= hi
    local empty = not workspace or (workspace.windows or 0) == 0
    if not valid and empty then
      repairs[#repairs + 1] = default
    end
  end

  if secondary then
    add_repair(primary, "1", 1, 5)
    add_repair(secondary, "6", 6, 10)
  else
    add_repair(primary, "1", 1, 10)
  end

  for _, workspace in ipairs(repairs) do
    hl.dispatch(hl.dsp.focus({ workspace = workspace }))
  end

  -- Repairing the secondary steals focus; return to the monitor the user was
  -- on if it is still valid.
  if focused and #repairs > 0 then
    local workspace = focused.active_workspace
    if workspace then
      hl.dispatch(hl.dsp.focus({ workspace = workspace.name }))
    end
  end
end

Notify.register({
  ["workspaces.assign"] = M.assign,
  ["workspaces.bind_focus"] = M.bind_focus,
  ["workspaces.repair_stale"] = M.repair_stale,
})

return M
