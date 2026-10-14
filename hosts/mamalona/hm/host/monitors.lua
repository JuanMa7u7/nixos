-- mamalona host monitors (nix-managed: hosts/mamalona/hm/host/monitors.lua).
-- Re-appended to ~/.config/hypr/custom/general.lua after every switch, so
-- hand-edits to the deployed file do not survive: edit this source instead.
-- 1: primary 144Hz
hl.monitor({ output = "desc:GGF MG600", mode = "1920x1080@144", position = "1080x1792", scale = 1 })
hl.workspace_rule({ workspace = "1", monitor = "DP-2", default = true, persistent = true })
hl.workspace_rule({ workspace = "2", monitor = "DP-2", persistent = true })
hl.workspace_rule({ workspace = "3", monitor = "DP-2", persistent = true })
hl.workspace_rule({ workspace = "4", monitor = "DP-2", persistent = true })
-- 2: vertical portrait
hl.monitor({ output = "desc:Hewlett Packard HP Z24i CNK5051MC0", mode = "1920x1200@60", position = "3000x1632", scale = 1, transform = 1 })
hl.workspace_rule({ workspace = "5", monitor = "DP-1", default = true, persistent = true })
hl.workspace_rule({ workspace = "6", monitor = "DP-1", persistent = true })
hl.workspace_rule({ workspace = "7", monitor = "DP-1", persistent = true })
-- 3: vertical portrait
hl.monitor({ output = "desc:BNQ BenQ GW2480 53L0006101Q", mode = "1920x1080@60", position = "0x1568", scale = 1, transform = 1 })
hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1", default = true, persistent = true })
hl.workspace_rule({ workspace = "9", monitor = "HDMI-A-1", persistent = true })
hl.workspace_rule({ workspace = "10", monitor = "HDMI-A-1", persistent = true })
-- 4: mirror of primary
hl.monitor({ output = "desc:Samsung Electric Company SAMSUNG 0x00000001", mode = "1920x1080@60", position = "1080x1413", scale = 1, mirror = "DP-2" })
