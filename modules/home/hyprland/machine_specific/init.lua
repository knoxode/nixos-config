local system = require("helpers.system")

local machines = {
  node = require("machine_specific.node"),
}

local default = {
  policy = {
    dynamic_monitors = true,
    automatic_brightness = true,
  },
}

return machines[system.hostname] or default
