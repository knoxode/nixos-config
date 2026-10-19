local system_helpers = require("helpers.system")
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
    return nil
  end

  local found = false
  local online = false

  for name in handle:lines() do
    local path = dir .. "/" .. name

    if system_helpers.read_file(path .. "/type") == "Mains" then
      local status = system_helpers.read_file(path .. "/online")

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
    return nil
  end
  return online
end

return M
