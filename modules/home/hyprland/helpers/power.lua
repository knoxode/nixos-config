local system_helpers = require("helpers.system")
local Notify = require("helpers.notify")

local M = {}

---@param on_AC boolean | nil
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

Notify.register({
  ["power.is_on_AC"] = M.is_on_AC,
})

return M
