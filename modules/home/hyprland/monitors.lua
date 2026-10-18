local node = require("node_specific")
local shared = require("shared")

---@param monitors HL.Monitor[]
---@param on_AC boolean?
function eval_monitors(monitors, on_AC)
  local external_mon_name = nil
  -- Only handle configurations with 1 or 2 monitors
  if #monitors == 0 or #monitors > 2 then
    return
  end

  if on_AC == nil then
    on_AC = shared.is_on_AC()
  end

  local max_refresh_rate = on_AC == false and 60.01 or math.huge

  local monitor_set_table = {}

  for _, mon in ipairs(monitors) do
    if mon.name ~= "eDP-1" then
      external_mon_name = mon.name
    end
    local set_output = mon.name
    local set_position
    local set_scale

    -- Position
    if #monitors == 1 then
      set_position = "auto"
    elseif mon.name == "eDP-1" then
      set_position = "auto"
    else
      set_position = "auto-left"
    end

    -- Find best supported mode
    local best_mode = nil

    for _, mode in ipairs(mon.available_modes) do
      local valid_refresh = mode.refresh_rate <= max_refresh_rate

      local valid_resolution = mode.height >= 720 and mode.height <= 2160

      if valid_refresh and valid_resolution then
        if not best_mode then
          best_mode = mode
        else
          local pixels = mode.width * mode.height
          local best_pixels = best_mode.width * best_mode.height

          if pixels > best_pixels or (pixels == best_pixels and mode.refresh_rate > best_mode.refresh_rate) then
            best_mode = mode
          end
        end
      end
    end

    if best_mode then
      -- Scaling
      if best_mode.height >= 2160 then
        set_scale = 2
      else
        set_scale = 1
      end

      -- Build monitor configuration
      local monitor_config = {
        output = set_output,
        mode = string.format("%dx%d@%.3f", best_mode.width, best_mode.height, best_mode.refresh_rate),
        position = set_position,
        scale = set_scale,
      }

      table.insert(monitor_set_table, monitor_config)
    end
  end

  -- Apply configurations
  for _, config in ipairs(monitor_set_table) do
    hl.monitor(config)
  end

  --Update workspace binds and locations

  if #monitors == 1 then
    for i = 1, 10 do
      hl.workspace_rule({ workspace = tostring(i), monitor = monitors[1].name })
    end
  elseif #monitors == 2 then
    for i = 1, 5 do
      local j = i + 5
      hl.workspace_rule({ workspace = tostring(j), monitor = "eDP-1" })
      hl.workspace_rule({ workspace = tostring(i), monitor = external_mon_name })
    end
  end
end

local function set_mon_dynamic()
  local monitors = hl.get_monitors()

  if shared.hostname == "node" then
    node.set_mon_node()
    return
  end

  shared.on_AC = shared.is_on_AC()
  eval_monitors(monitors, shared.on_AC)
end

set_mon_dynamic()

hl.on("monitor.added", set_mon_dynamic)
hl.on("monitor.removed", set_mon_dynamic)
hl.on("config.reloaded", set_mon_dynamic)
hl.on("hyprland.start", set_mon_dynamic)

--A timer to check every thirty minutes what the monitor brightness should be - based on how bright it's likely to be
--outside.
hl.on("hyprland.start", function()
  hl.timer(function()
    local on_AC = shared.is_on_AC()
    local brightness = shared.DecideBrightness(on_AC)

    hl.exec_cmd(string.format("noctalia msg brightness-set '*' %d%%", brightness))

    hl.notification.create({
      text = string.format("Brightness polled: %d%% (%s)", brightness, on_AC and "AC" or "Battery"),
      timeout = 5000,
    })
  end, { timeout = 30 * 60 * 1000, type = "repeat" })
end)
