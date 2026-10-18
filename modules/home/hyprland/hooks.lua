local previousGraphics = nil
local previousMonitors = nil

function OnBatteryHook()
  -- Save settings only once
  if not previousGraphics then
    previousGraphics = {
      blur = hl.get_config("decoration.blur.enabled"),
      shadow = hl.get_config("decoration.shadow.enabled"),
    }
  end

  hl.notification.create({
    text = "Switched to battery. Disabling fancy graphics.",
    timeout = 3000,
  })

  hl.config({
    decoration = {
      blur = { enabled = false },
      shadow = { enabled = false },
    },
  })

  if not previousMonitors then
    previousMonitors = {}

    local monitors = hl.get_monitors()

    for _, mon in ipairs(monitors) do
      local originalMode = string.format("%dx%d@%.2f", mon.width, mon.height, mon.refresh_rate)

      table.insert(previousMonitors, {
        output = mon.name,
        mode = originalMode,
      })

      local batteryMode = string.format("%dx%d@60", mon.width, mon.height)

      hl.monitor({
        output = mon.name,
        mode = batteryMode,
      })
    end
  end
end

function OnACHook()
  hl.notification.create({
    text = "Switched to AC. Restoring graphics.",
    timeout = 3000,
  })

  if previousGraphics then
    hl.config({
      decoration = {
        blur = { enabled = previousGraphics.blur },
        shadow = { enabled = previousGraphics.shadow },
      },
    })

    previousGraphics = nil
  end

  if previousMonitors then
    for _, mon in ipairs(previousMonitors) do
      hl.monitor({
        output = mon.output,
        mode = mon.mode,
      })
    end

    previousMonitors = nil
  end
end
