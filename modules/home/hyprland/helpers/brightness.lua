local sun = require("helpers.sun")
local Notify = require("helpers.notify")

local M = {}

---@param on_AC boolean
---@return integer
function M.calculate(on_AC)
  local now = os.time()
  local start_time, end_time = sun.GetEffectiveSunTimes()

  local brightness = 1

  if start_time and end_time and end_time > start_time then
    if now > start_time and now < end_time then
      local transition = math.min(3600, (end_time - start_time) / 2)

      local progress = math.min((now - start_time) / transition, (end_time - now) / transition, 1)

      local intensity = (1 - math.cos(math.pi * progress)) / 2

      local maximum = on_AC and 100 or 25
      brightness = 1 + (maximum - 1) * intensity
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
  hl.exec_cmd(command)
end

return M
