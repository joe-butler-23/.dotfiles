#!/bin/bash

DOTFILES_DIR="$HOME/.dotfiles"

# Ensure the script always runs from the correct directory
cd "$DOTFILES_DIR" || { echo "❌ Failed to change directory to $DOTFILES_DIR"; exit 1; }

# Ensure target directories exist
mkdir -p "$HOME"
mkdir -p "$HOME/.config"

echo "🔍 Checking and stowing individual dotfiles..."
stow -v -t "$HOME" home

echo "🔍 Checking and stowing configuration directories..."
stow -v -t "$HOME/.config" config

echo "🎉 All dotfiles are correctly stowed!"
