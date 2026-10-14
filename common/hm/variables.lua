-- Shared app variables override (nix-managed: common/hm/variables.lua).
-- Deployed as ~/.config/hypr/custom/variables.lua after every switch.
-- end-4's keybinds load this AFTER its own defaults (see "Copy these to
-- ~/.config/hypr/custom/variables.lua" in hyprland/variables.lua), so these
-- win without touching upstream files.
--
-- Rule of thumb: end-4 defaults are "first installed wins" launcher chains.
-- Anything pinned here stays put no matter what gets installed later.
-- (qsConfig is deliberately NOT overridden: shell paths depend on it.)

-- SUPER+Return, SUPER+T, CTRL+ALT+T: kitty with this repo's config, always.
terminal = "kitty -1"
-- SUPER+E: Dolphin. end-4's blessed file manager (first in its preference
-- list AND the only one with shipped theme integration: dolphinrc +
-- kdeglobals + kde-material-you-colors recolor it with every wallpaper).
-- Installed via common/hm/packages/applications.nix.
fileManager = "dolphin"
-- SUPER+W: end-4's default order prefers google-chrome-stable, which is
-- installed, so it would win over zen. Pin zen explicitly (binary is zen-beta).
browser = "zen-beta"
-- SUPER+C: upstream would resolve to `code` today (windsurf/antigravity
-- absent), but pin it so a future windsurf/antigravity install can't hijack it.
codeEditor = "code"
-- CTRL+SUPER+SHIFT+ALT+W: upstream resolves to onlyoffice (wps absent).
-- Pinned to match; both onlyoffice and libreoffice are installed.
officeSoftware = "onlyoffice-desktopeditors"
-- SUPER+X: upstream GUI editors (kate/gnome-text-editor/emacs) are all absent,
-- so it falls through to nvim-in-kitty today. Pin that (micro also absent).
textEditor = "kitty -1 nvim"
-- CTRL+SUPER+V: upstream resolves to pavucontrol-qt (flake-installed). Pinned.
volumeMixer = "pavucontrol-qt"
-- SUPER+I: quickshell settings page (always available in-session). Pinned to
-- the upstream value for documentation; change only to swap settings frontends.
settingsApp = "XDG_CURRENT_DESKTOP=gnome ~/.config/hypr/hyprland/scripts/launch_first_available.sh 'qs -p ~/.config/quickshell/$qsConfig/settings.qml' 'systemsettings' 'gnome-control-center' 'better-control'"
-- CTRL+SHIFT+Escape: upstream ends in `kitty -1 fish -c btop`, but fish is not
-- installed (repo uses zsh), so the bind was dead. btop straight in kitty.
taskManager = "kitty -1 btop"

-- Workspace grouping: workspaces are handled in banks of this size for
-- group-aware navigation (upstream default; change with care).
workspaceGroupSize = 10
