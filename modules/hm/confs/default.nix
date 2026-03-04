{ config, lib, pkgs, ... }:
let
  declaredHydeThemes = config.hydenix.hm.theme.themes or [ ];
  declaredHydeThemesArgs = lib.escapeShellArgs declaredHydeThemes;
in
{
  home.file = {
    ".config/hypr/userprefs.conf" = pkgs.lib.mkForce {
      text = ''
        exec-once = ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
        exec-once = ${pkgs.xhost}/bin/xhost +SI:localuser:root

        ${builtins.readFile ./hypr.conf}
      '';
      force = true;
      mutable = true;
    };
    ".config/hyde/config.toml" = pkgs.lib.mkForce {
      source = ./config.toml;
      force = true;
      mutable = true;
    };
    ".config/hypr/windowrules.conf" = pkgs.lib.mkForce {
      source = ./windowrules.conf;
      force = true;
      mutable = true;
    };
    ".local/share/hypr/windowrules.conf" = pkgs.lib.mkForce {
      source = ./windowrules.conf;
      force = true;
      mutable = true;
    };
  };

  home.activation = {
    wallbashGtkAssetsWritable = lib.hm.dag.entryBefore [ "linkGeneration" ] ''
      assets_dir="$HOME/.local/share/themes/Wallbash-Gtk/gtk-4.0/assets"

      # Some theme switchers replace this path with a symlink into /etc/profiles,
      # which is read-only and breaks Home Manager's per-file linking.
      if [ -L "$assets_dir" ]; then
        rm -f "$assets_dir"
      fi

      mkdir -p "$assets_dir"
    '';

    hyprlandDropDeprecatedGestures = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -f "$HOME/.local/share/hypr/defaults.conf" ]; then
        ${pkgs.gnused}/bin/sed -i '/^[[:space:]]*gesture[[:space:]]*=/d' "$HOME/.local/share/hypr/defaults.conf"
      fi
    '';

    waybarEnableCaffeineOnStartup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      waybar_config="$HOME/.config/waybar/waybar.jsonc"

      if [ -f "$waybar_config" ] && ! ${pkgs.gnugrep}/bin/grep -Fq '"start-activated": true' "$waybar_config"; then
        ${pkgs.gnused}/bin/sed -i '/"tooltip-format-deactivated": "Caffeine Mode Inactive"/a\        "start-activated": true,' "$waybar_config"
      fi
    '';

    hydePruneUndeclaredThemes = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      themes_dir="$HOME/.config/hyde/themes"

      if [ ! -d "$themes_dir" ]; then
        exit 0
      fi

      keep_file="$(${pkgs.coreutils}/bin/mktemp)"
      trap '${pkgs.coreutils}/bin/rm -f "$keep_file"' EXIT

      for theme in ${declaredHydeThemesArgs}; do
        printf '%s\n' "$theme" >> "$keep_file"
      done

      find "$themes_dir" -mindepth 1 -maxdepth 1 -type d | while IFS= read -r theme_dir; do
        theme_name="$(${pkgs.coreutils}/bin/basename "$theme_dir")"

        if ! ${pkgs.gnugrep}/bin/grep -Fxq "$theme_name" "$keep_file"; then
          rm -rf "$theme_dir"
        fi
      done
    '';
  };

  home.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = "1";
    NIXPKGS_ALLOW_INSECURE = "1";
    XCURSOR_SIZE = "24";
    STEAM_COMPAT_TOOLS_HOME = "\${HOME}/.local/share/Steam/compatibilitytools.d";
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "\${HOME}/.steam/root/compatibilitytools.d:\${STEAM_COMPAT_TOOLS_HOME}";
    PROTON_EXPERIMENTAL =
      "\${HOME}/.local/share/Steam/steamapps/common/Proton - Experimental";
    PROTON_GE = "\${STEAM_COMPAT_TOOLS_HOME}";
    PROTON = "\${PROTON_EXPERIMENTAL}";
    SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS = "0";
    STEAM_USE_MANGOAPP = "1";
    GOPATH = "\${HOME}/go";
  };

  home.sessionPath = [
    "\${HOME}/go/bin"
  ];
}
