{ lib, ... }:
{
  # Applies this host's Hypr fragments AFTER illogical-flake's
  # copyIllogicalImpulseConfigs activation (which owns ~/.config/hypr).
  # Filenames follow the end-4 recommended custom/ convention and are picked
  # up by hyprland.lua's custom include without touching upstream defaults.
  home.activation.applyHostHyprCustom = lib.hm.dag.entryAfter [ "copyIllogicalImpulseConfigs" ] ''
    $DRY_RUN_CMD mkdir -p "$HOME/.config/hypr/custom"
    $DRY_RUN_CMD cp -f ${./host/monitors.conf} "$HOME/.config/hypr/custom/monitors.conf"
    $DRY_RUN_CMD cp -f ${./host/keybinds-extra.conf} "$HOME/.config/hypr/custom/keybinds-extra.conf"
    $DRY_RUN_CMD chmod u+w "$HOME/.config/hypr/custom/monitors.conf" "$HOME/.config/hypr/custom/keybinds-extra.conf"
  '';
}
