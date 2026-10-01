-- thinkpad-l15 autostart (nix-managed: hosts/thinkpad-l15/hm/host/execs.lua).
-- Deployed as ~/.config/hypr/custom/execs.lua after every switch (full
-- ownership: the end-4 default file is empty). Hand-edits to the deployed
-- file do not survive: edit this source instead.
-- Pattern follows end-4: one-shot commands inside hl.on("hyprland.start").
-- Already covered by end-4, NOT repeated here: gnome-keyring, cliphist
-- watchers, easyeffects, geoclue agent, cursor theme, shell itself.
-- No polkit agent: quickshell provides it (built with SERVICE_POLKIT=ON).
hl.on("hyprland.start", function()
    -- Forward bluetooth media keys to MPRIS
    hl.exec_cmd("mpris-proxy")
    -- Chat, minimized to tray
    hl.exec_cmd("sleep 3 && vesktop --start-minimized")
    -- Tailscale tray
    hl.exec_cmd("ktailctl")
end)
