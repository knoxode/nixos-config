local M = {}

M.mainMod = "SUPER"
M.terminal = "ghostty"
M.fileManager = "nautilus"
M.menu = "hyprlauncher"

local restarting = false

function M.on_battery()
	local file = io.open("/sys/class/power_supply/AC/online", "r")
	if not file then
		return nil
	end

	local status = file:read("*all")
	file:close()

	return tonumber(status) == 0
end

function M.get_hostname()
	local pipe = io.popen("hostname")
	if not pipe then
		return nil
	end

	local result = pipe:read("*l")
	pipe:close()

	return result
end

M.hostname = M.get_hostname()

return M
