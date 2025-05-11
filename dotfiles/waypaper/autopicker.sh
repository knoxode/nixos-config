#!/usr/bin/env bash
WALLPAPER_DIR="$HOME/Documents/syncthing/asr/DesktopBackground"
INTERVAL=300 # Time in seconds between wallpaper changes (e.g., 3600s = 1 hour)
DYNAMIC_WALLPAPER_FILE="$HOME/.cache/.wallpaper"

waypaper --restore
sleep 300

while true; do
    for IMAGE in "$WALLPAPER_DIR"/*; do
        cp "$IMAGE" "$DYNAMIC_WALLPAPER_FILE" 
        waypaper --fill fill --wallpaper "$IMAGE" --backend swww
        sleep $INTERVAL
    done
done

