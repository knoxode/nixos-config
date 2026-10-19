require("monitors")
require("workspaces")
require("binds")
require("exec")
require("appearance")
require("windowrules")
require("devices")
require("layouts")
require("misc")
require("animations")
require("env")
require("gpu")
require("hooks")
require("node_specific")

local events = require("events")
Notify = require("helpers.notify")
Display = require("systems.display")

Notify.set_debug(true)

events.register()

hl.config({
  render = {
    direct_scanout = 2,
    new_render_scheduling = true,
    use_fp16 = 1,
    cm_auto_hdr = true,
    send_content_type = true,
    cm_enabled = true,
  },
  quirks = {
    prefer_hdr = 2,
  },
  cursor = {
    no_hardware_cursors = 1,
  },
})

for i = 1, 10 do
  hl.workspace_rule({ workspace = tostring(i), persistent = true })
end
