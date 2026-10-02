{ lib, ... }:
{
  # Applies this host's Hypr fragments AFTER illogical-flake's
  # copyIllogicalImpulseConfigs activation (which owns ~/.config/hypr).
  # end-4's Lua setup (hyprland.lua) only loads custom/*.lua, so host
  # fragments are APPENDED to the end-4-owned custom/general.lua and
  # custom/keybinds.lua (both re-created from defaults each switch).
  # NOTE: the `>>` appends run unprefixed on purpose: prefixing them with
  # $DRY_RUN_CMD would redirect the echoed text into the config on dry runs.
  home.activation.applyHostHyprCustom = lib.hm.dag.entryAfter [ "copyIllogicalImpulseConfigs" ] ''
    $DRY_RUN_CMD mkdir -p "$HOME/.config/hypr/custom"
    # legacy .conf fragments are not loaded by the Lua setup; drop leftovers
    $DRY_RUN_CMD rm -f "$HOME/.config/hypr/custom/monitors.conf" "$HOME/.config/hypr/custom/keybinds-extra.conf"
    cat ${./host/monitors.lua} >> "$HOME/.config/hypr/custom/general.lua"
    cat ${./host/keybinds.lua} >> "$HOME/.config/hypr/custom/keybinds.lua"
    # NVIDIA Wayland session env, mamalona-only. HM home.sessionVariables only
    # reach login shells (~/.zprofile), NOT greetd-launched Hyprland sessions,
    # so set them where the compositor guarantees them: custom/env.lua is
    # sourced by hyprland.lua right after hyprland/env.lua and applies to the
    # whole session. Kept in sync with home.sessionVariables in ../home.nix.
    cat >> "$HOME/.config/hypr/custom/env.lua" <<'LUAEOF'
-- nix-managed (hosts/mamalona/hm/host.nix): NVIDIA Wayland, mamalona-only
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")
LUAEOF
    # execs.lua is fully owned (end-4 default is empty): overwrite, don't append
    $DRY_RUN_CMD cp -f ${./host/execs.lua} "$HOME/.config/hypr/custom/execs.lua"
    $DRY_RUN_CMD chmod u+w "$HOME/.config/hypr/custom/general.lua" "$HOME/.config/hypr/custom/keybinds.lua" "$HOME/.config/hypr/custom/execs.lua"
  '';
}
