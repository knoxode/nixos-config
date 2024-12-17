#!/bin/bash

# Retrieve the current wallpaper path from swww
WALLPAPER=$(swww query | awk -F 'image: ' '{print $2}' | xargs)

# Paths to the template and active configuration
TEMPLATE_CONFIG=~/.config/hypr/hyprlock.conf.template
ACTIVE_CONFIG=~/.config/hypr/hyprlock.conf

# Ensure the directory exists
mkdir -p ~/.config/hypr

# Replace placeholder in the template and write to the active config
sed "s|{{ SWWW_WALL }}|$WALLPAPER|g" "$TEMPLATE_CONFIG" > "$ACTIVE_CONFIG"

echo "Updated hyprlock configuration with wallpaper: $WALLPAPER"

