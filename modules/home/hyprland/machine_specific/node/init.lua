local system = require("helpers.system")

local M = {}

local policies = {
  node = {
    dynamic_monitors = false,
    automatic_brightness = true,
  },

  default = {
    dynamic_monitors = true,
    automatic_brightness = true,
  },
}

M.policy = policies[system.hostname] or policies.default

if system.hostname == "node" then
  M.monitors = require("machine_specific.node.monitors")
end

return M
