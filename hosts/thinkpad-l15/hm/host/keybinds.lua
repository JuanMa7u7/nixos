-- thinkpad-l15 host keybinds (nix-managed: hosts/thinkpad-l15/hm/host/keybinds.lua).
-- Re-appended to ~/.config/hypr/custom/keybinds.lua after every switch.
-- end-4 already binds SUPER+T/E/W/C/Q/F via first-available app launchers,
-- so only host-specific additions live here (adding those would double-fire).
hl.bind("SUPER + ALT + H", hl.dsp.exec_cmd('kitty zsh -lc "ssh juan_ma7u7@mamalona"'), { description = "SSH to mamalona" })
-- NOTE: SUPER+T opens kitty via common/hm/variables.lua (terminal override),
-- so no separate kitty bind is needed here.
