{ config, lib, pkgs, ... }:
{
  programs.illogical-impulse = {
    enable = true;
    dotfiles = {
      fish.enable = false; # repo uses zsh (common/hm/programs/zsh.nix) — avoid fish overwrite
      kitty.enable = false; # repo owns kitty via common/hm/programs/kitty.nix (see restore below)
      starship.enable = false; # repo owns starship via common/hm/programs/starship.nix (see override below)
    };
  };

  # Cursor, declaratively: end-4 runs `hyprctl setcursor Bibata-Modern-Classic 24`
  # at startup, which silently falls back to X defaults if the theme is not
  # installed. home.pointerCursor installs it and covers GTK/XWayland apps.
  # Change name/size here, then `hyprctl setcursor <Name> <Size>` if needed.
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # The flake sets programs.starship.enable=false when
  # dotfiles.starship.enable=false, which conflicts with the repo's
  # programs.starship.enable=true. The repo keeps owning the prompt, so force it.
  programs.starship.enable = lib.mkForce true;

  # NOTE (recommended end-4): wayland.windowManager.hyprland is intentionally
  # NOT enabled. Hypr config is owned by illogical-flake's activation copy of
  # dots/.config/hypr (entry: ~/.config/hypr/hyprland.lua, user overrides in
  # ~/.config/hypr/custom/). Per-host fragments in hosts/<host>/hm/host.nix are
  # applied AFTER that copy step (entryAfter "copyIllogicalImpulseConfigs") so
  # they survive every re-switch.
  #
  # Same ordering hazard applies to repo-owned kitty/starship configs: the
  # upstream copy does `rm -rf` per directory under ~/.config, which would
  # silently wipe the HM-managed files. Re-apply them deterministically here.
  home.activation.restoreHmManagedConfigs =
    lib.hm.dag.entryAfter [ "copyIllogicalImpulseConfigs" ] ''
      ${lib.optionalString config.programs.kitty.enable ''
        $DRY_RUN_CMD cp -f ${config.xdg.configFile."kitty/kitty.conf".source} "$HOME/.config/kitty/kitty.conf"
        $DRY_RUN_CMD chmod u+w "$HOME/.config/kitty/kitty.conf"
      ''}
      ${lib.optionalString config.programs.starship.enable ''
        $DRY_RUN_CMD cp -f ${config.home.file.".config/starship.toml".source} "$HOME/.config/starship.toml"
        $DRY_RUN_CMD chmod u+w "$HOME/.config/starship.toml"
      ''}
    '';
}
