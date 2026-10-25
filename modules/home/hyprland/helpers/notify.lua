--- Operation-scoped diagnostic notifications.
---
--- Any function can be registered as a diagnostic identifier: top-level
--- event operations as well as individual helper functions. Registered
--- functions can be selectively enabled through configure().
---
--- scope() pushes the operation onto a stack of active diagnostic scopes
--- and pops it afterwards, so nested calls (event operation -> helper ->
--- sub-helper) each contribute a frame to the diagnostic path.
---
--- Debug output is enabled when ANY frame in the active stack is enabled.
--- This allows enabling either a whole event operation or a single
--- sub-function, wherever it is called from.
---
--- Diagnostic messages are prefixed with the full active scope path,
--- e.g. "[startup > update_brightness > apply] message".

local M = {}

-- Lookup of functions for which debugging is enabled.
-- Function references are used as keys instead of string identifiers.
local debug_operations = {}

-- Maps registered function references to their readable names.
-- Used to identify the originating operation in notifications.
local operation_names = {}

-- Stack of currently executing scopes (innermost last).
local active_scopes = {}

--- Register named functions for diagnostic output.
---
--- Accepts a table mapping names to functions. Both event operations
--- and helper functions can be registered; each module registers its
--- own diagnostic units at load time.
---
---@param operations table<string, function>
function M.register(operations)
  for name, fn in pairs(operations) do
    assert(type(fn) == "function", "Diagnostic operation must be a function: " .. name)

    operation_names[fn] = name
  end
end

--- Configure which registered functions produce debug notifications.
---
--- Only functions included in config.debug are enabled.
--- All other operations remain functional but produce no debug output.
---
--- Functions are identified by their references, allowing direct
--- selection using module tables with LuaLS autocomplete.
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

--- Execute a function within a diagnostic scope.
---
--- The scope is pushed onto the active stack for the duration of the
--- call and removed afterwards, even if execution fails, preventing
--- diagnostic state from leaking into later operations.
---
--- xpcall() executes the operation while capturing any errors.
---
---@param operation function
---@param ... any
function M.scope(operation, ...)
  assert(operation_names[operation], "Unregistered diagnostic operation")

  table.insert(active_scopes, {
    name = operation_names[operation],
    debug_enabled = debug_operations[operation] == true,
  })

  -- Execute the operation, capturing errors and return values.
  local results = table.pack(xpcall(operation, debug.traceback, ...))

  -- Restore the previous context regardless of success or failure.
  table.remove(active_scopes)

  -- Propagate errors after restoring the diagnostic context.
  if not results[1] then
    error(results[2], 0)
  end

  return table.unpack(results, 2, results.n)
end

--- Build the active scope path, e.g. "startup > update_brightness > apply".
local function scope_path()
  local names = {}

  for _, frame in ipairs(active_scopes) do
    table.insert(names, frame.name)
  end

  return table.concat(names, " > ")
end

--- Display a debug notification if any active scope is enabled.
---
--- Helpers can call this unconditionally. The diagnostic system decides
--- whether to display the message based on the active scopes.
---
---@param message string
function M.debug(message)
  local enabled = false

  for _, frame in ipairs(active_scopes) do
    if frame.debug_enabled then
      enabled = true
      break
    end
  end

  if not enabled then
    return
  end

  hl.notification.create({
    text = "[" .. scope_path() .. "] " .. message,
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
