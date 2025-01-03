#!/bin/sh

# Infinite loop
while true; do
  # Wait for 5 minutes (300 seconds)
  sleep 300

  # Change the wallpaper
  waypaper --random

  # Get the current wallpaper path
  wallpaper_path=$(swww query | awk -F'image: ' '/image:/ {print $2}')

  # Copy the template file to the actual configuration file
  cp ~/.config/hypr/hyprlock.conf.template ~/.config/hyprlock.conf

  # Update the wallpaper path in the hyprlock.conf file
  sed -i "s|path = .*|path = $wallpaper_path|" ~/.config/hyprlock.conf
done

