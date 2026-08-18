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
require("node_specific")

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
