#!/bin/bash

if hyprctl monitors | grep -q "eDP-1"; then
    hyprctl keyword monitor "eDP-1,disable"
else
    hyprctl keyword monitor "eDP-1,1920x1080@60,-1920x0,1"
fi
