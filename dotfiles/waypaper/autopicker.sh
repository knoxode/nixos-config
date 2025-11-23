#!/usr/bin/env bash
WALLPAPER_DIR="$HOME/Pictures/DesktopBackground"
INTERVAL=300 # Time in seconds between wallpaper changes (e.g., 3600s = 1 hour)
DYNAMIC_WALLPAPER_FILE="$HOME/.cache/.wallpaper"

INIT_IMAGE=$(waypaper --list | jq -r '.[0].wallpaper')
waypaper --restore
cp "$INIT_IMAGE" "$DYNAMIC_WALLPAPER_FILE"

sleep $INTERVAL

while true; do
  for IMAGE in $(find -L "$WALLPAPER_DIR" -type f | shuf); do
    cp "$IMAGE" "$DYNAMIC_WALLPAPER_FILE"
    waypaper --fill fill --wallpaper "$IMAGE" --backend swww
    sleep $INTERVAL
  done
done
