local M = {}

local debug_enabled = false

---@param enabled boolean
function M.set_debug(enabled)
  debug_enabled = enabled
end

---@param message string
function M.debug(message)
  if not debug_enabled then
    return
  end

  hl.notification.create({
    text = message,
    timeout = 5000,
    icon = "warn",
  })
end

---@param message string
function M.info(message)
  hl.notification.create({
    text = message,
    timeout = 5000,
    icon = "info",
  })
end

return M
