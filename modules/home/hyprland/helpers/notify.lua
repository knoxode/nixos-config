--- Operation-scoped diagnostic notifications.
---
--- Any function can be registered as a diagnostic identifier: top-level
--- event operations as well as individual helper functions. Registered
--- functions can be selectively enabled through configure().
---
--- debug() inspects the live Lua call stack (debug.getinfo) to find the
--- registered functions currently executing. Output is enabled when ANY
--- registered function on the stack is enabled, so a whole event
--- operation or a single sub-function can be enabled independently of
--- how it was called. Messages are prefixed with the path of registered
--- frames, e.g. "[monitorChange > update_brightness] message".
---
--- scope() wraps top-level event operations to capture errors and write
--- them to the diagnostic log; it does not participate in the debug
--- decision.

local M = {}

-- Lookup of functions for which debugging is enabled.
-- Function references are used as keys instead of string identifiers.
local debug_operations = {}

-- Names of enabled diagnostic functions (reverse lookup for the
-- call-stack check in debug()).
local debug_enabled_names = {}

-- Maps registered function references to their readable names.
local operation_names = {}

-- File handle for the persistent diagnostic log, opened lazily.
-- nil means "not tried yet"; false means "unavailable, don't retry".
local log_file = nil

--- Open the diagnostic log file once.
---
--- Written to $XDG_STATE_HOME/hypr/ (default ~/.local/state/hypr/).
--- If the file cannot be opened, file logging is disabled silently
--- for the rest of the session and notifications remain the only sink.
local function get_log_file()
  if log_file ~= nil then
    return log_file
  end

  local state_dir = os.getenv("XDG_STATE_HOME") or os.getenv("HOME") .. "/.local/state"
  local path = state_dir .. "/hypr/alexos.log"

  log_file = io.open(path, "a")

  if not log_file then
    -- Directory may not exist yet; create it once and retry.
    os.execute("mkdir -p " .. state_dir .. "/hypr")
    log_file = io.open(path, "a") or false
  end

  if log_file == false then
    return nil
  end

  return log_file
end

--- Append a record to the diagnostic log file.
---
---@param level string
---@param message string
local function log_to_file(level, message)
  local file = get_log_file()

  if not file then
    return
  end

  file:write(string.format("%s %s %s\n", os.date("%Y-%m-%d %H:%M:%S"), level, message))
  file:flush()
end

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
    debug_enabled_names[operation_names[operation]] = true
  end
end

--- Collect the registered functions on the current call stack, from
--- outermost to innermost.
---
---@return string[] names
local function registered_call_path()
  local names = {}
  local depth = 1

  while true do
    local info = debug.getinfo(depth, "f")
    if not info then
      break
    end

    local name = operation_names[info.func]
    if name then
      table.insert(names, 1, name)
    end

    depth = depth + 1
  end

  return names
end

--- Execute an operation while capturing errors into the diagnostic log.
---
--- xpcall() executes the operation while capturing any errors.
---
---@param operation function
---@param ... any
function M.scope(operation, ...)
  assert(operation_names[operation], "Unregistered diagnostic operation")

  -- Execute the operation, capturing errors and return values.
  local results = table.pack(xpcall(operation, debug.traceback, ...))

  -- Propagate errors after logging them.
  if not results[1] then
    log_to_file("ERROR", string.format("[%s] %s", operation_names[operation], results[2]))

    -- One short user-facing notification pointing at the log; the
    -- traceback itself stays in the file.
    hl.notification.create({
      text = operation_names[operation] .. " failed - see alexos.log",
      timeout = 8000,
      icon = "warn",
    })

    error(results[2], 0)
  end

  return table.unpack(results, 2, results.n)
end

--- Display a debug record if any registered function currently on the
--- call stack is enabled.
---
--- Debug output goes to the diagnostic log only: the log is the
--- diagnostic channel; notifications are reserved for information a
--- user should act on. Follow the log with:
---   tail -f ~/.local/state/hypr/alexos.log
---
---@param message string
function M.debug(message)
  local path = registered_call_path()

  local enabled = false
  for _, name in ipairs(path) do
    if debug_enabled_names[name] then
      enabled = true
      break
    end
  end

  if not enabled then
    return
  end

  log_to_file("DEBUG", "[" .. table.concat(path, " > ") .. "] " .. message)
end

--- Display an informational notification regardless of debug settings.
---
--- Unlike debug(), this is intended for messages that should remain
--- visible even when diagnostic output is disabled.
---
---@param message string
function M.info(message)
  log_to_file("INFO", message)

  hl.notification.create({
    text = message,
    timeout = 5000,
    icon = "info",
  })
end

return M
