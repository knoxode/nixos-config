local Notify = require("helpers.notify")
local M = {}

---@param monitor HL.Monitor
---@param monitor_count integer
---@return string
local function get_position(monitor, monitor_count)
  if monitor_count == 1 or monitor.name == "eDP-1" then
    return "auto"
  end

  return "auto-right"
end

---@param mode table
---@return integer
local function get_scale(mode)
  return mode.height >= 2160 and 2 or 1
end

---@param monitor HL.Monitor
local function find_best_mode(monitor, max_refresh_rate)
  local best_mode = nil
  local modes = monitor.available_modes
  ---@cast modes table

  for _, mode in ipairs(modes) do
    local valid_refresh = mode.refresh_rate <= max_refresh_rate
    local valid_resolution = mode.height >= 720 and mode.height <= 2160

    if valid_refresh and valid_resolution then
      if not best_mode then
        best_mode = mode
      else
        local pixels = mode.height * mode.width
        local best_pixels = best_mode.height * best_mode.width
        if pixels > best_pixels or (pixels == best_pixels and mode.refresh_rate > best_mode.refresh_rate) then
          best_mode = mode
        end
      end
    end
  end
  return best_mode
end

---@param monitor HL.Monitor
---@param monitor_count integer
---@param max_refresh_rate number
function M.build_config(monitor, monitor_count, max_refresh_rate)
  local mode = find_best_mode(monitor, max_refresh_rate)

  if not mode then
    Notify.info(string.format("No valid mode found for %s, leaving it at Hyprland defaults", monitor.name))

    return nil
  end

  return {
    output = monitor.name,
    -- Always pass the mode explicitly: omitting it would fall back to
    -- Hyprland's "preferred" default if omitted fields reset on apply.
    mode = string.format("%dx%d@%.3f", mode.width, mode.height, mode.refresh_rate),
    position = get_position(monitor, monitor_count),
    scale = get_scale(mode),
  }
end

function M.apply_config(config)
  hl.monitor(config)
end

Notify.register({
  ["monitors.build_config"] = M.build_config,
  ["monitors.apply_config"] = M.apply_config,
})

return M
