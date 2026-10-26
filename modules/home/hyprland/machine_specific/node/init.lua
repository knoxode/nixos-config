local system = require("helpers.system")

local M = {}

local policies = {
  node = {
    dynamic_monitors = false,
    automatic_brightness = true,
    primary_desc = "Acer Technologies XB273U GX",
  },

  default = {
    dynamic_monitors = true,
    automatic_brightness = true,
    primary_desc = nil,
  },
}

M.policy = policies[system.hostname] or policies.default

if system.hostname == "node" then
  -- Node's monitor rules are declarative; requiring the module applies them.
  require("machine_specific.node.monitors")
end

return M
