#!/usr/bin/env bash

direction="$1"

# try focusing in the given direction
if ! yabai -m window --focus "$direction"; then
    # move to the adjacent display
    case "$direction" in
        west)  yabai -m display --focus west ;;
        east)  yabai -m display --focus east ;;
        north) yabai -m display --focus north ;;
        south) yabai -m display --focus south ;;
    esac

    # find all windows on the now-focused display
    windows=$(yabai -m query --windows --display | jq -r '[.[] | select(.minimized == false)] | sort_by(.frame.x, .frame.y) | .[].id')

    if [ -n "$windows" ]; then
        case "$direction" in
            east|south)  target=$(echo "$windows" | head -n1) ;;   # first window
            west|north)  target=$(echo "$windows" | tail -n1) ;;   # last window
        esac
        yabai -m window --focus "$target"
    fi
fi
