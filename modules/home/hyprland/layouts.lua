hl.config({
  general = {
    layout = "scrolling",
  },
  scrolling = {
    column_width = 1.0,
  },
})

---@param monitor HL.Monitor
hl.on("monitor.focused", function(monitor)
  local ratio = monitor.width / monitor.height

  local width
  if ratio >= 3.2 then
    width = 0.3 -- 32:9
  elseif ratio >= 2.1 then
    width = 0.7 -- 21:9
  else
    width = 1.0 -- 16:9 and below
  end

  hl.config({
    scrolling = {
      column_width = width,
    },
  })
end)
