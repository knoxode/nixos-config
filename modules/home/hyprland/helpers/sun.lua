local Notify = require("helpers.notify")
local host = require("host")

local M = {}

local cached_sun = nil
local cached_date = nil

-- Time of the last failed fetch. Failed lookups are not retried for
-- an hour to avoid running the curl pipeline on every event while
-- offline.
local last_failure = 0

local RETRY_INTERVAL = 60 * 60

---@return table|nil
function M.GetSunTimes()
  local now = os.time()

  if now - last_failure < RETRY_INTERVAL then
    return nil
  end

  local today = os.date("%Y-%m-%d")

  if cached_sun and cached_date == today then
    return cached_sun
  end

  -- Coordinates come from the Nix-generated host.lua.
  local cmd = string.format(
    [[
    curl -fsS --connect-timeout 3 --max-time 5 \
      "https://api.sunrise-sunset.org/json?lat=%s&lng=%s&date=%s&formatted=0" |
    jq -r 'if .status == "OK" then .results | .sunrise, .sunset else empty end' |
    while read -r time; do date -d "$time" +%%s; done
  ]],
    host.latitude,
    host.longitude,
    today
  )

  local handle = io.popen(cmd)
  if not handle then
    last_failure = now
    return nil
  end

  local sunrise = tonumber(handle:read("*l"))
  local sunset = tonumber(handle:read("*l"))
  handle:close()

  if not sunrise or not sunset then
    last_failure = now
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

  local today = os.date("*t", os.time())

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

Notify.register({
  ["sun.get_effective_sun_times"] = M.GetEffectiveSunTimes,
})

return M
