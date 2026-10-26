local M = {}

-- Hostname comes from the Nix-generated host.lua (hosts/<host>/variables.nix),
-- so no subprocess is needed at config load time.
M.hostname = require("host").hostname

function M.read_file(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end

  local value = file:read("*l")
  file:close()

  return value
end

return M
