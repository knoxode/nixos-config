#!/usr/bin/env bash
WALLPAPER_DIR="$HOME/Pictures/DesktopBackground"
INTERVAL=300 # Time in seconds between wallpaper changes (e.g., 3600s = 1 hour)
DYNAMIC_WALLPAPER_FILE="$HOME/.cache/.wallpaper"

RANDOM_WAYPAPER_OUTPUT=$(waypaper --random 2>&1)
INIT_IMAGE=$(printf '%s\n' "$RANDOM_WAYPAPER_OUTPUT" | awk ' NR==1 {sub(/^Selected file: /,"");print; exit }')

cp "$INIT_IMAGE" "$DYNAMIC_WALLPAPER_FILE"

sleep $INTERVAL

while true; do
  first=true
  # Note: you said filenames are controlled so splitting is acceptable
  for IMAGE in $(find -L "$WALLPAPER_DIR" -type f | shuf); do
    # If this is the first candidate after INIT_IMAGE, skip if it's identical
    if $first && [ "$IMAGE" = "$INIT_IMAGE" ]; then
      # skip this occurrence, but still mark that we've seen the first candidate
      first=false
      continue
    fi
    first=false

    cp -- "$IMAGE" "$DYNAMIC_WALLPAPER_FILE"
    waypaper --fill fill --wallpaper "$IMAGE" --backend swww
    sleep "$INTERVAL"
  done
done
