#!/run/current-system/sw/bin/sh

# if [ -n "$WAYLAND_DISPLAY" ] || [ -n "$DISPLAY" ]; then
#     sudo -u "$USER" hyprctl reload 2>/dev/null || true
#     sudo -u "$USER" notify-send "$1" "Rebuild complete. Ready to roll 🗿🤙🏻" 2>/dev/null || true
# fi

hyprctl reload
