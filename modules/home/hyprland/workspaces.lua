local function set_ws_dynamic()
	local monitors = hl.get_monitors()

	if #monitors == 1 then
		for i = 1, 10 do
			hl.dispatch(hl.dsp.workspace.move({
				workspace = i,
				monitor = monitors[1],
			}))
		end
	elseif #monitors == 2 then
		for i = 1, 5 do
			hl.dispatch(hl.dsp.workspace.move({
				workspace = i,
				monitor = monitors[2],
			}))
		end
		for i = 6, 10 do
			hl.dispatch(hl.dsp.workspace.move({
				workspace = i,
				monitor = monitors[1],
			}))
		end
	end
end

set_ws_dynamic()
hl.on("monitor.added", set_ws_dynamic)
hl.on("monitor.removed", set_ws_dynamic)
