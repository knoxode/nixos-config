hl.config({
  misc = {
    force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
    disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
    disable_splash_rendering = true,
  },
  general = {
    resize_on_border = true,
  },
  debug = {
    vfr = true,
  },
})

local QALCULATE_SCALE = 0.75

hl.on("monitor.focused", function(monitor)
  local win = hl.get_window("class:io.github.Qalculate.qalculate-qt")
  if not win then
    return
  end

  local size = monitor.height * 0.75

  --Move Qalculate to newly focused monitor
  hl.dispatch(hl.dsp.window.move({
    window = win,
    monitor = monitor.name,
  }))

  --Resize it such that it occupies the same fraction of
  --screen space for each monitor.
  hl.dispatch(hl.dsp.window.resize({
    window = win,
    x = monitor.width * 0.25,
    y = monitor.height * 0.9,
    relative = false,
  }))

  --Moves window to righthand side and horizontally centred.
  local gaps = hl.get_config("general.gaps_out")

  hl.dispatch(hl.dsp.window.move({
    window = win,
    x = monitor.x + monitor.width * 0.75 - gaps.right - win.at.x,
    y = monitor.y + monitor.height * 0.05 - win.at.y,
    relative = true,
  }))
end)
