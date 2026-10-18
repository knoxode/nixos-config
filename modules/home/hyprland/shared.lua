local M = {}

M.mainMod = "SUPER"
M.terminal = "ghostty"
M.fileManager = "nautilus"
M.menu = "hyprlauncher"
M.on_AC = nil

---@return table|nil
function M.GetSunTimes()
  local cmd = [[
    curl -fsS "https://api.sunrise-sunset.org/json?lat=51.75&lng=-1.25&formatted=0" |
    jq -r '.results | .sunrise, .sunset' |
    while read -r time; do date -d "$time" +%s; done
  ]]

  local handle = io.popen(cmd)
  if not handle then
    return nil
  end

  local sunrise = tonumber(handle:read("*l"))
  local sunset = tonumber(handle:read("*l"))
  handle:close()

  if not sunrise or not sunset then
    return nil
  end

  local sunrise_time = os.date("*t", sunrise)
  local sunset_time = os.date("*t", sunset)

  return {
    sunrise = sunrise,
    sunset = sunset,
    sunrise_before_6 = sunrise_time.hour < 6,
    sunset_after_10 = sunset_time.hour >= 22,
  }
end

function M.GetCurrentTime()
  return os.time()
end

---@return integer|nil start_time
---@return integer|nil end_time
function M.GetEffectiveSunTimes()
  local sun = M.GetSunTimes()

  if not sun then
    return nil, nil
  end

  if sun.sunrise_before_6 or sun.sunset_after_10 then
    return sun.sunrise, sun.sunset
  end

  local today = os.date("*t", M.GetCurrentTime())

  local start_time = os.time({
    year = today.year,
    month = today.month,
    day = today.day,
    hour = 6,
    min = 0,
    sec = 0,
  })

  local end_time = os.time({
    year = today.year,
    month = today.month,
    day = today.day,
    hour = 22,
    min = 0,
    sec = 0,
  })

  return start_time, end_time
end

---@param on_AC boolean|nil
---@return integer
function M.DecideBrightness(on_AC)
  local now = M.GetCurrentTime()
  local start_time, end_time = M.GetEffectiveSunTimes()

  if not start_time or not end_time then
    return 1
  end

  if now <= start_time or now >= end_time then
    return 1
  end

  local progress = (now - start_time) / (end_time - start_time)
  local intensity = math.sin(math.pi * progress)

  local brightness = 1 + 99 * intensity

  if not on_AC then
    brightness = brightness * 0.25
  end

  return math.max(1, math.floor(brightness + 0.5))
end

function M.is_on_AC()
  local file = io.open("/sys/class/power_supply/AC0/online", "r")

  if not file then
    return nil
  end

  local status = file:read("*l")
  file:close()

  return status == "1"
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

function CheckAC()
  M.on_AC = M.is_on_AC()

  hl.notification.create({
    text = "AC status: " .. tostring(M.on_AC),
    timeout = 5000,
  })
end

return M
