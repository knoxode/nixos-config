local M = {}

---@param ctx table
function M.configure(ctx)
  local profile = ctx.on_AC and "performance" or "power-saver"

  hl.exec_cmd("powerprofilesctl set " .. profile)
end

return M
