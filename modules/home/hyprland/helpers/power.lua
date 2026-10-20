local system_helpers = require("helpers.system")
local Notify = require("helpers.notify")

local M = {}

---@param on_AC boolean | nil
function M.SetPowerSettings(on_AC)
  local brightness = M.DecideBrightness(on_AC)
  local profile = on_AC and "performance" or "power-saver"

  local commands = {
    string.format("noctalia msg brightness-set '*' %d", brightness),
    string.format("powerprofilesctl set %s", profile),
  }

  for _, command in ipairs(commands) do
    Notify.debug("Executing: " .. command)
    hl.exec_cmd(command)
  end
end

function M.is_on_AC()
  local dir = "/sys/class/power_supply"

  local handle = io.popen("ls -1 " .. dir .. " 2>/dev/null")
  if not handle then
    Notify.debug("AC detection: Failed to read power supply directory")
    return nil
  end

  local found = false
  local online = false

  for name in handle:lines() do
    local path = dir .. "/" .. name

    local supply_type = system_helpers.read_file(path .. "/type")
    local status = system_helpers.read_file(path .. "/online")

    Notify.debug(string.format("Power supply: %s\nType: %s\nOnline: %s", name, tostring(supply_type), tostring(status)))

    if supply_type == "Mains" then
      if status == "1" then
        online = true
      end

      if status == "0" or status == "1" then
        found = true
      end
    end
  end

  handle:close()

  if not found then
    Notify.debug("AC detection: No valid mains power supply found")
    return nil
  end

  Notify.debug(string.format("AC detection result: %s", online and "AC connected" or "Battery"))

  return online
end

return M
