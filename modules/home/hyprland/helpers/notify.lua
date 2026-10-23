--- Operation-scoped diagnostic notifications.
---
--- Event functions are registered as diagnostic identifiers and can
--- be selectively enabled through configure().
---
--- scope() establishes a diagnostic context for an operation.
--- All synchronous functions called within that scope inherit its
--- debug setting, without needing to receive or check it themselves.
---
--- Only the root operation determines whether debugging is enabled.
--- Nested scopes cannot override the root operation's decision.

local M = {}

-- Lookup of operations for which debugging is enabled.
-- Function references are used as keys instead of string identifiers.
local debug_operations = {}

-- Maps registered function references to their readable names.
-- Used to identify the originating operation in notifications.
local operation_names = {}

-- The currently executing root operation, or nil when outside a scope.
local active_scope = nil

--- Register named operations for diagnostic output.
---
--- Accepts the Events.operations table and automatically associates
--- each function with its name. This avoids maintaining a separate
--- registry of diagnostic operation identifiers.
---
---@param operations table<string, function>
function M.register(operations)
  for name, fn in pairs(operations) do
    assert(type(fn) == "function", "Diagnostic operation must be a function: " .. name)

    operation_names[fn] = name
  end
end

--- Configure which registered operations produce debug notifications.
---
--- Only operations included in config.debug are enabled.
--- All other operations remain functional but produce no debug output.
---
--- Operations are identified by their function references, allowing
--- direct selection using Events.operations with LuaLS autocomplete.
---
---@param config { debug: function[] }
function M.configure(config)
  debug_operations = {}

  for _, operation in ipairs(config.debug or {}) do
    assert(type(operation) == "function", "Diagnostic operation must be a function")

    assert(operation_names[operation], "Unregistered diagnostic operation")

    debug_operations[operation] = true
  end
end

--- Execute an operation within a diagnostic scope.
---
--- If no scope is active, this operation becomes the root and its
--- configured debug setting determines whether messages are shown.
---
--- If a scope is already active, the nested operation inherits the
--- existing root context instead of creating a new one.
---
--- xpcall() executes the operation while capturing any errors.
--- The previous scope is restored afterwards, even if execution fails,
--- preventing diagnostic settings from leaking into later operations.
---
---@param operation function
---@param ... any
function M.scope(operation, ...)
  assert(operation_names[operation], "Unregistered diagnostic operation")

  local previous_scope = active_scope

  -- Only root operations determine whether debugging is enabled.
  if not previous_scope then
    active_scope = {
      name = operation_names[operation],
      debug_enabled = debug_operations[operation] == true,
    }
  end

  -- Execute the operation, capturing errors and return values.
  local results = table.pack(xpcall(operation, debug.traceback, ...))

  -- Restore the previous context regardless of success or failure.
  active_scope = previous_scope

  -- Propagate errors after restoring the diagnostic context.
  if not results[1] then
    error(results[2], 0)
  end

  return table.unpack(results, 2, results.n)
end

--- Display a debug notification if the active root operation is enabled.
---
--- Helpers can call this unconditionally. The diagnostic system decides
--- whether to display the message based on the active scope.
---
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

--- Display an informational notification regardless of debug settings.
---
--- Unlike debug(), this is intended for messages that should remain
--- visible even when diagnostic output is disabled.
---
---@param message string
function M.info(message)
  hl.notification.create({
    text = message,
    timeout = 5000,
    icon = "info",
  })
end

return M
