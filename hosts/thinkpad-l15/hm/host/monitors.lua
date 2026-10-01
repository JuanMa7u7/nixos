-- thinkpad-l15 host monitors (nix-managed: hosts/thinkpad-l15/hm/host/monitors.lua).
-- Re-appended to ~/.config/hypr/custom/general.lua after every switch, so
-- hand-edits to the deployed file do not survive: edit this source instead.
hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1 })
hl.workspace_rule({ workspace = "1", monitor = "eDP-1", default = true, persistent = true })
hl.workspace_rule({ workspace = "2", monitor = "eDP-1", persistent = true })
hl.workspace_rule({ workspace = "3", monitor = "eDP-1", persistent = true })
hl.workspace_rule({ workspace = "4", monitor = "eDP-1", persistent = true })
hl.workspace_rule({ workspace = "5", monitor = "eDP-1", persistent = true })
