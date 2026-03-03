{ lib, pkgs, ... }:
{
  home.file = {
    # ".config/hypr/userprefs.conf" = pkgs.lib.mkForce {
    #   source = ./hypr.conf;
    #   force = true;
    #   mutable = true;
    # };
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
