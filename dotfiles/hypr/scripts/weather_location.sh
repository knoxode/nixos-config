#!/usr/bin/env bash

cache_file="/tmp/weather_ip_cache.txt"
expiry_time=250
current_date=$(date +%s)

# Create cache file if missing
if [ ! -f "$cache_file" ]; then
    mkdir -p "$(dirname "$cache_file")"
    touch "$cache_file"
fi

last_modified=$(stat -c %Y "$cache_file")
time_diff=$((current_date - last_modified))

# If cache is fresh and non-empty, just output cached data and exit
if [ $time_diff -lt $expiry_time ] && [ -s "$cache_file" ]; then
    cat "$cache_file"
    exit
fi

# Fetch fresh data
icon=$(curl -s 'wttr.in?format=%c')
condition=$(curl -s 'wttr.in?format=%C')
temperature=$(curl -s 'wttr.in?format=%t' | sed -E 's/^\+([0-9])/\1/')
weather_info="$icon <span color='gray'>·</span> $condition <span color='gray'>·</span> $temperature"

location_full=$(curl -s https://ipapi.co/json | jq -r '"\(.city), \(.country_name)"' 2>/dev/null)

city=$(echo "$location_full" | cut -d',' -f1)
country_full=$(echo "$location_full" | cut -d',' -f2 | xargs)

country_initials=$(echo "$country_full" | awk '{for(i=1;i<=NF;i++) printf "%s", toupper(substr($i,1,1))}')

location="$city, $country_initials"

# Combine and write to cache
combined="$location <span color='gray'>·</span> $weather_info"
echo "$combined" > "$cache_file"

# Output combined info
echo "$combined"

