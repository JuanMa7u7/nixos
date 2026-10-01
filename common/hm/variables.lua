-- Shared app variables override (nix-managed: common/hm/variables.lua).
-- Deployed as ~/.config/hypr/custom/variables.lua after every switch.
-- end-4's keybinds load this AFTER its own defaults (see "Copy these to
-- ~/.config/hypr/custom/variables.lua" in hyprland/variables.lua), so these
-- win without touching upstream files.
-- SUPER+T (and friends) open kitty with this repo's config, always.
terminal = "kitty -1"
