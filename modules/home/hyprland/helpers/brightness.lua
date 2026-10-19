-- helpers/brightness.lua

local sun = require("helpers.sun")

local M = {}

---@param on_AC boolean
---@return integer
function M.calculate(on_AC)
  local now = os.time()
  local start_time, end_time = sun.GetEffectiveSunTimes()

  local brightness = 1

  if start_time and end_time and end_time > start_time then
    if now > start_time and now < end_time then
      local progress = (now - start_time) / (end_time - start_time)
      local intensity = math.sin(math.pi * progress)

      brightness = 1 + 99 * intensity

      if not on_AC then
        brightness = brightness * 0.25
      end
    end
  end

  brightness = math.max(1, math.min(100, math.floor(brightness + 0.5)))

  Notify.debug(
    string.format(
      "Brightness calculation:\nTime: %s\nPower: %s\nResult: %d%%",
      os.date("%H:%M", now),
      on_AC and "AC" or "Battery",
      brightness
    )
  )

  return brightness
end

---@param brightness integer
function M.apply(brightness)
  local command = string.format("noctalia msg brightness-set '*' %d", brightness)

  Notify.debug("Executing: " .. command)
  os.execute(command)
end

return M
