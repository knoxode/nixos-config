#!/bin/sh

# Validate input argument
if [ -z "$1" ]; then
  echo "Usage: $0 <workspace_number>"
  exit 1
fi

# Workspace numbers
workspace_primary="$1"
workspace_secondary=$((workspace_primary + 5))

# Dispatch workspaces
hyprctl dispatch workspace "$workspace_primary"
hyprctl dispatch workspace "$workspace_secondary"
