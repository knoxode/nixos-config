local shared = require("shared")

---@param on_AC boolean
function SetPowerSettings(on_AC)
  local brightness = shared.DecideBrightness(on_AC)
  local profile = on_AC and "performance" or "power-saver"

  local commands = {
    string.format("noctalia msg brightness-set '*' %d%%", brightness),
    string.format("powerprofilesctl set %s", profile),
  }

  for _, command in ipairs(commands) do
    hl.exec_cmd(command)
  end
end

---@param on_AC boolean
function SetGraphicsOpts(on_AC)
  if not on_AC then
    hl.config({
      decoration = {
        blur = {
          enabled = false,
        },
        shadow = {
          enabled = false,
        },
      },
    })
  else
    hl.config({
      decoration = {
        blur = {
          enabled = true,
          size = 3,
          passes = 1,
          vibrancy = 0.1696,
        },
        shadow = {
          enabled = true,
          range = 4,
          render_power = 3,
          color = 0xee1a1a1a,
        },
      },
    })
  end
end

function OnBatteryHook()
  shared.on_AC = false

  SetGraphicsOpts(shared.on_AC)

  eval_monitors(hl.get_monitors(), shared.on_AC)

  hl.notification.create({
    text = "Switched to battery. Performing Battery Optimisations.",
    timeout = 3000,
  })
  SetPowerSettings(shared.on_AC)
end

function OnACHook()
  shared.on_AC = true

  SetGraphicsOpts(shared.on_AC)

  eval_monitors(hl.get_monitors(), shared.on_AC)
  hl.notification.create({
    text = "Switched to AC. Enabling Fancy Graphics.",
    timeout = 3000,
  })
  SetPowerSettings(shared.on_AC)
end
