#!/usr/bin/env bash

echo "called $(date)" >>/tmp/brightnessctl-script.log
brightnessctl get >>/tmp/brightnessctl-script.log

# Get current brightness and max brightness
current=$(brightnessctl get)
max=$(brightnessctl max)

# Calculate current brightness percentage
percent=$((100 * current / max))

# Calculate new brightness
if ((percent <= 10)); then
  brightnessctl set 1%
else
  brightnessctl set 10%-
fi
