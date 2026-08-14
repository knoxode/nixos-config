local node = require("node_specific")
local shared = require("shared")

local function set_mon_dynamic()
	local monitors = hl.get_monitors()
	if shared.hostname == "node" then
		node.set_mon_node()
		return
	end
	if #monitors == 1 then
		for i = 1, 10 do
			hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1" })
		end
		local hostname = shared.get_hostname()
		local on_battery = shared.on_battery()

		hl.monitor({
			output = "eDP-1",
			mode = "1920x1080@60hz",
			position = "auto",
			scale = "1",
		})
	elseif #monitors == 2 then
		for i = 1, 5 do
			local j = i + 5
			hl.workspace_rule({ workspace = tostring(j), monitor = monitors[1].name })
			hl.workspace_rule({ workspace = tostring(i), monitor = monitors[2].name })
		end
		hl.monitor({
			output = monitors[1].name,
			mode = "highrr",
			position = "auto-left",
			scale = "1",
		})
		-- SECOND MONITOR
		-- Attempt high refresh rate, and if that fails try "preferred"
		hl.monitor({
			output = monitors[2].name,
			mode = "highrr",
			position = "auto",
			scale = "1",
		})
		if monitors[2].height < 1080 then
			hl.monitor({
				output = monitors[2].name,
				mode = "preferred",
				position = "auto",
				scale = "1",
			})
		-- If resolution is greater than 1440p after initial set (should be 4K), double scaling for nicer viewing
		elseif monitors[2].height > 1440 then
			hl.monitor({
				output = monitors[2].name,
				mode = "highrr",
				position = "auto",
				scale = "2",
			})
		end
	end
end

set_mon_dynamic()

hl.on("monitor.added", set_mon_dynamic)
hl.on("monitor.removed", set_mon_dynamic)
hl.on("config.reloaded", set_mon_dynamic)
hl.on("hyprland.start", set_mon_dynamic)
