#!/bin/bash
WALLPAPER_DIR="$HOME/Documents/syncthing/asr/DesktopBackground"
INTERVAL=30 # Time in seconds between wallpaper changes (e.g., 3600s = 1 hour)

while true; do
    for IMAGE in "$WALLPAPER_DIR"/*; do
        waypaper --fill fill --wallpaper "$IMAGE" --backend swww
        sleep $INTERVAL
    done
done

