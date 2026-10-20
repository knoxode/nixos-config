local Notify = require("helpers.notify")

local M = {}

function M.read_file(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end

  local value = file:read("*l")
  file:close()

  return value
end

function M.get_hostname()
  local pipe = io.popen("hostname")
  if not pipe then
    return nil
  end

  local result = pipe:read("*l")
  pipe:close()

  return result
end

M.hostname = M.get_hostname()

function CheckAC()
  M.on_AC = M.is_on_AC()

  Notify.debug("AC status: " .. tostring(M.on_AC))
end

function M.GetCurrentTime()
  return os.time()
end

return M
