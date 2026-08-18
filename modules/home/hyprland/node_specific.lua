local M = {}

function M.set_mon_node()
	local monitors = hl.get_monitors()
	if #monitors == 0 then
		return
	end

	if #monitors >= 2 then
		for i = 1, 5 do
			local j = i + 5
			hl.workspace_rule({ workspace = tostring(j), monitor = monitors[1].name })
			hl.workspace_rule({ workspace = tostring(i), monitor = monitors[2].name })
		end
	end

	for i = 1, math.min(2, #monitors) do
		if monitors[i].description == "Acer Technologies XB273U GX 3052185574200" then
			hl.monitor({
				output = monitors[i].name,
				mode = "highrr",
				position = "auto",
				scale = "1",
				bitdepth = 10,
				cm = "auto",
				supports_hdr = true,
				sdrbrightness = 4,
				sdrsaturation = 1.15,
				sdr_min_luminance = 80,
				sdr_max_luminance = 420,
				sdr_eotf = "srgb",
			})
		else
			hl.monitor({
				output = monitors[i].name,
				mode = "highrr",
				position = "auto-left",
				scale = "1",
			})
		end
	end
end

return M
