local M = {}

function M.configure()
  local monitors = hl.get_monitors()

  if #monitors == 0 then
    return
  end

  for i = 1, math.min(2, #monitors) do
    if monitors[i].description == "Acer Technologies XB273U GX 3052185574200" then
      hl.monitor({
        output = monitors[i].name,
        mode = "highrr",
        position = "auto",
        scale = "1",
        bitdepth = 10,
        cm = "hdr",
        supports_hdr = true,
        sdrbrightness = 2,
        sdrsaturation = 0.98,
        sdr_min_luminance = 0,
        sdr_max_luminance = 400,
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
