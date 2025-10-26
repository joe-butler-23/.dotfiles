# ~/.zprofile — login shell/session initialisation

if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
    exec uwsm start -F hyprland.desktop
fi

# (Optional) If you start Hyprland via a login shell, other agents go here.
# e.g. gpg-agent, ssh-agent, dbus/user services, keychain, uwsm, etc.