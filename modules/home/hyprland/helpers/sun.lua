local system_helpers = require("helpers.system")
local M = {}

local cached_sun = nil
local cached_date = nil

---@return table|nil
function M.GetSunTimes()
  local today = os.date("%Y-%m-%d")

  if cached_sun and cached_date == today then
    return cached_sun
  end

  -- Explicitly request sun times for the current local date
  local cmd = string.format(
    [[
    curl -fsS --connect-timeout 3 --max-time 5 \
      "https://api.sunrise-sunset.org/json?lat=51.75&lng=-1.25&date=%s&formatted=0" |
    jq -r 'if .status == "OK" then .results | .sunrise, .sunset else empty end' |
    while read -r time; do date -d "$time" +%%s; done
  ]],
    today
  )

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

  cached_sun = {
    sunrise = sunrise,
    sunset = sunset,
  }

  cached_date = today

  return cached_sun
end

---@return integer|nil start_time
---@return integer|nil end_time
function M.GetEffectiveSunTimes()
  local sun = M.GetSunTimes()

  if not sun then
    Notify.debug("Sun times: Failed to retrieve sunrise/sunset")
    return nil, nil
  end

  local today = os.date("*t", system_helpers.GetCurrentTime())

  -- Minimum brightness period: 06:00 to 22:00
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

  -- Extend the period for earlier sunrises or later sunsets
  local effective_start = math.min(sun.sunrise, start_time)
  local effective_end = math.max(sun.sunset, end_time)

  Notify.debug(
    string.format(
      "Sun times:\nSunrise: %s\nSunset: %s\nEffective start: %s\nEffective end: %s",
      os.date("%Y-%m-%d %H:%M", sun.sunrise),
      os.date("%Y-%m-%d %H:%M", sun.sunset),
      os.date("%Y-%m-%d %H:%M", effective_start),
      os.date("%Y-%m-%d %H:%M", effective_end)
    )
  )

  return effective_start, effective_end
end

return M
