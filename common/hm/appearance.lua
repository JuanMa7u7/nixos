-- Shared window transparency (nix-managed: common/hm/appearance.lua).
-- Re-appended to ~/.config/hypr/custom/general.lua after every switch, so
-- hand-edits to the deployed file do not survive: edit this source instead.
-- Partial hl.config tables merge with end-4's own (same pattern end-4 uses
-- for its zoom-toggle binds), so nothing else in decoration is touched.
hl.config({
    decoration = {
        active_opacity = 0.95,
        inactive_opacity = 0.95,
        fullscreen_opacity = 1.0,
    },
})
