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

return M
