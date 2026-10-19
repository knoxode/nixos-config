local node = require("node_specific")
local M = {}

local function update_brightness()
  local on_AC = shared.is_on_AC()
  local brightness = shared.DecideBrightness(on_AC)

  hl.exec_cmd(string.format("noctalia msg brightness-set '*' %d", brightness))
end

--A timer to check every thirty minutes what the monitor brightness should be - based on how bright it's likely to be
--outside.
hl.on("hyprland.start", function()
  hl.timer(update_brightness, {
    timeout = 30 * 60 * 1000,
    type = "repeat",
  })
end)

return M
