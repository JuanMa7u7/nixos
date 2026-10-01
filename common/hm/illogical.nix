{ config, lib, pkgs, ... }:
{
  programs.illogical-impulse = {
    enable = true;
    dotfiles = {
      fish.enable = false; # repo uses zsh (common/hm/programs/zsh.nix) — avoid fish overwrite
      kitty.enable = false; # repo owns kitty via common/hm/programs/kitty.nix (see restore below)
      starship.enable = true; # end-4 owns the prompt (dots/.config/starship.toml); repo module disabled
    };
  };

  # Cursor, declaratively: end-4 runs `hyprctl setcursor Bibata-Modern-Classic 24`
  # at startup, which silently falls back to X defaults if the theme is not
  # installed. home.pointerCursor installs it and covers GTK/XWayland apps.
  # Change name/size here, then `hyprctl setcursor <Name> <Size>` if needed.
  home.pointerCursor = {
    enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # The flake only flips programs.starship.enable; zsh integration is ours
  # (the flake never sets it, so no conflict).
  programs.starship.enableZshIntegration = true;

  # Upstream compat: end-4's generate_colors_material.py targets
  # materialyoucolor 2.x (`primary_paletteKeyColor`); nixpkgs ships 3.x
  # (`primaryPaletteKeyColor`). Unpatched, the script crashes with KeyError,
  # material_colors.scss stays empty, and kitty shows parse errors on every
  # launch. Single occurrence in the script; sed is a no-op once upstream
  # renames it, so drop this then.
  home.activation.patchQuickshellCompat =
    lib.hm.dag.entryAfter [ "copyIllogicalImpulseConfigs" ] ''
      $DRY_RUN_CMD sed -i 's/primary_paletteKeyColor/primaryPaletteKeyColor/g' "$HOME/.config/quickshell/ii/scripts/colors/generate_colors_material.py"
    '';

  # Shared app-variables override (terminal = kitty). end-4's keybinds load
  # custom/variables.lua after their own defaults, so this wins cleanly.
  # Deployed with cp (full ownership: the end-4 default file is empty).
  home.activation.applyHyprVariables =
    lib.hm.dag.entryAfter [ "copyIllogicalImpulseConfigs" ] ''
      $DRY_RUN_CMD cp -f ${./variables.lua} "$HOME/.config/hypr/custom/variables.lua"
      $DRY_RUN_CMD chmod u+w "$HOME/.config/hypr/custom/variables.lua"
    '';

  # Shared Hypr appearance fragment (window transparency). Appended to the
  # end-4-owned custom/general.lua after its copy step, same mechanism as the
  # per-host fragments in hosts/*/hm/host.nix (append order between the two
  # does not matter: they are independent statements).
  home.activation.applyHyprAppearance =
    lib.hm.dag.entryAfter [ "copyIllogicalImpulseConfigs" ] ''
      cat ${./appearance.lua} >> "$HOME/.config/hypr/custom/general.lua"
      $DRY_RUN_CMD chmod u+w "$HOME/.config/hypr/custom/general.lua"
    '';

  # NOTE (recommended end-4): wayland.windowManager.hyprland is intentionally
  # NOT enabled. Hypr config is owned by illogical-flake's activation copy of
  # dots/.config/hypr (entry: ~/.config/hypr/hyprland.lua, user overrides in
  # ~/.config/hypr/custom/). Per-host fragments in hosts/<host>/hm/host.nix are
  # applied AFTER that copy step (entryAfter "copyIllogicalImpulseConfigs") so
  # they survive every re-switch.
  #
  # Same ordering hazard applies to the repo-owned kitty config: the
  # upstream copy does `rm -rf` per directory under ~/.config, which would
  # silently wipe the HM-managed file. Re-apply it deterministically here.
  # (Starship is fully end-4-owned now, so it needs no restore.)
  home.activation.restoreHmManagedConfigs =
    lib.hm.dag.entryAfter [ "copyIllogicalImpulseConfigs" ] ''
      ${lib.optionalString config.programs.kitty.enable ''
        # cmp guard: HM's linkGeneration may already have linked dest to this
        # exact source (same inode content) — bare `cp -f` errors out as
        # "same file" and fails the whole switch (seen 2026-10-01).
        if ! cmp -s ${config.xdg.configFile."kitty/kitty.conf".source} "$HOME/.config/kitty/kitty.conf"; then
          $DRY_RUN_CMD cp -f ${config.xdg.configFile."kitty/kitty.conf".source} "$HOME/.config/kitty/kitty.conf"
          $DRY_RUN_CMD chmod u+w "$HOME/.config/kitty/kitty.conf"
        fi
      ''}
      # Caelestia-era leftover: zsh used to prefer this file via STARSHIP_CONFIG.
      # Nothing regenerates it (caelestia-colors is gone); remove once, keep gone.
      $DRY_RUN_CMD rm -f "$HOME/.config/starship-dynamic.toml"
    '';
}
