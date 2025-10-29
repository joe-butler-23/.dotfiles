#!/bin/bash

# Script to automatically update the keymap visualization
# This script should be run after making changes to your keymap.c file

# Set paths
QMK_DIR="$HOME/qmk_firmware"
KEYMAP_DIR="$QMK_DIR/keyboards/crkbd/keymaps/joebutler23"
DOTFILES_DIR="$HOME/.dotfiles/config/keyboard"

# Ensure we're in the QMK directory
cd "$QMK_DIR" || { echo "Error: Could not change to QMK directory"; exit 1; }

# Compile the keymap
echo "Compiling keymap..."
qmk compile -kb crkbd/rev4_1/standard -km joebutler23

# Generate YAML from keymap.c
echo "Generating YAML from keymap.c..."
qmk c2json "$KEYMAP_DIR/keymap.c" | keymap parse -c 10 -q - > "$KEYMAP_DIR/crkbd_joebutler23.yaml"

# Generate SVG from YAML
echo "Generating SVG from YAML..."
keymap draw "$KEYMAP_DIR/crkbd_joebutler23.yaml" > "$KEYMAP_DIR/crkbd_joebutler23.ortho.svg"

# Convert SVG to PNG
echo "Converting SVG to PNG..."
convert "$KEYMAP_DIR/crkbd_joebutler23.ortho.svg" "$DOTFILES_DIR/crkbd_keymap.png"

# Copy the PNG to the dotfiles directory
echo "Copying PNG to dotfiles directory..."
cp "$KEYMAP_DIR/crkbd_joebutler23.ortho.svg" "$DOTFILES_DIR/crkbd_keymap.svg"

echo "Keymap visualization updated successfully!"
echo "PNG image: $DOTFILES_DIR/crkbd_keymap.png"
echo "SVG image: $DOTFILES_DIR/crkbd_keymap.svg"
