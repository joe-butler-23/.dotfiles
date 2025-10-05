#!/bin/bash

# Check for external monitors (excluding eDP-1)
EXTERNAL_MONITORS=$(hyprctl monitors | grep -v "eDP-1" | grep "Monitor" | wc -l)

if [[ "$EXTERNAL_MONITORS" -eq 0 ]]; then
    # No external monitors → Ensure eDP-1 is enabled
    hyprctl keyword monitor "eDP-1,1920x1080@60,0x0,1"
fi
