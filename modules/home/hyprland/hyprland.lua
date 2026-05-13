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

hl.config({
	scrolling = {
		fullscreen_on_one_column = true,
	},
})

for i = 1, 10 do
	hl.workspace_rule({ workspace = tostring(i), persistent = true })
end
