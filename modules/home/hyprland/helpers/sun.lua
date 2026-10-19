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

  local cmd = [[
    curl -fsS --connect-timeout 3 --max-time 5 \
      "https://api.sunrise-sunset.org/json?lat=51.75&lng=-1.25&formatted=0" |
    jq -r 'if .status == "OK" then .results | .sunrise, .sunset else empty end' |
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

  cached_sun = {
    sunrise = sunrise,
    sunset = sunset,
    sunrise_before_6 = sunrise_time.hour < 6,
    sunset_after_10 = sunset_time.hour >= 22,
  }

  cached_date = today

  return cached_sun
end

---@return integer|nil start_time
---@return integer|nil end_time
---@return integer|nil start_time
---@return integer|nil end_time
function M.GetEffectiveSunTimes()
  local sun = M.GetSunTimes()

  if not sun then
    return nil, nil
  end

  local today = os.date("*t", system_helpers.GetCurrentTime())

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

  return math.min(sun.sunrise, start_time), math.max(sun.sunset, end_time)
end

return M
