#!/usr/bin/env bash

direction="$1"

# Try to focus in the given direction
if ! yabai -m window --focus "$direction"; then
    case "$direction" in
        west)  yabai -m display --focus west ;;
        east)  yabai -m display --focus east ;;
        north) yabai -m display --focus north ;;
        south) yabai -m display --focus south ;;
    esac
fi

# Always ensure we end up on a visible window
windows=$(yabai -m query --windows --display | jq -r '[.[] | select(.minimized == false)] | sort_by(.frame.x, .frame.y) | .[].id')

if [ -n "$windows" ]; then
    case "$direction" in
        east|south)  target=$(echo "$windows" | head -n1) ;;
        west|north)  target=$(echo "$windows" | tail -n1) ;;
    esac
    yabai -m window --focus "$target"
fi
