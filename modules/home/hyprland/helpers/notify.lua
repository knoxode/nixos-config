local Operations = require("diagnostics.operations")

local M = {}

local debug_operations = {}
local active_scope = nil

-- Build a lookup of valid operation identifiers.
local valid_operations = {}

for _, operation in pairs(Operations) do
  valid_operations[operation] = true
end

---Configure enabled diagnostic operations.
---@param config { debug: DiagnosticOperation[] }
function M.configure(config)
  debug_operations = {}

  for _, operation in ipairs(config.debug or {}) do
    assert(valid_operations[operation], "Unknown diagnostic operation: " .. tostring(operation))

    debug_operations[operation] = true
  end
end

---Execute a function within a diagnostic scope.
---Nested scopes inherit the root operation's debug state.
---@param name DiagnosticOperation
---@param fn function
function M.scope(name, fn)
  assert(valid_operations[name], "Unknown diagnostic operation: " .. tostring(name))

  local previous_scope = active_scope

  if not previous_scope then
    active_scope = {
      name = name,
      debug_enabled = debug_operations[name] == true,
    }
  end

  local results = table.pack(xpcall(fn, debug.traceback))

  active_scope = previous_scope

  if not results[1] then
    error(results[2], 0)
  end

  return table.unpack(results, 2, results.n)
end

---@param message string
function M.debug(message)
  if not active_scope or not active_scope.debug_enabled then
    return
  end

  hl.notification.create({
    text = "[" .. active_scope.name .. "] " .. message,
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
