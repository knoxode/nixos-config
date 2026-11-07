require("workspaces")
require("binds")
require("appearance")
require("windowrules")
require("devices")
require("layouts")
require("misc")
require("animations")
require("env")
require("gpu")

local Events = require("events")
local Notify = require("helpers.notify")
local Diagnostics = require("diagnostics")

Notify.register(Events.operations)

Notify.configure({
  debug = {},
})

Events.register()

-- Start applications after the startup workspace assignment has run.
require("exec")

-- Machine-specific policy and declarative monitor rules.
local machine = require("machine_specific")

-- Node-specific stale-workspace repair also disables apps restoring a stale
-- initial workspace.
if machine.policy.repair_stale then
  hl.config({
    misc = {
      initial_workspace_tracking = 0,
    },
  })
end

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
    no_hardware_cursors = 0,
  },
})

for i = 1, 10 do
  hl.workspace_rule({ workspace = tostring(i), persistent = true })
end
