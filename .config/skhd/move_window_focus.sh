#!/usr/bin/env bash

# move_window_focus.sh
# Usage: move_window_focus.sh <direction>
# Example: move_window_focus.sh east

dir="$1"

if [ -z "$dir" ]; then
  echo "Usage: $0 <west|east|north|south>"
  exit 1
fi

# Get ID of currently focused window
id=$(yabai -m query --windows --window | jq -r '.id')

# If no window is focused, exit safely
if [ -z "$id" ] || [ "$id" = "null" ]; then
  echo "No focused window found."
  exit 1
fi

# Move window to target display
yabai -m window --display "$dir"

# Change focus to that display
yabai -m display --focus "$dir"

# Re-focus the same window
yabai -m window --focus "$id"

