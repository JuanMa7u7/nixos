{ pkgs, lib, ... }:{
  home.file = {
    # Hyprland
    ".config/hypr/userprefs.conf" = pkgs.lib.mkForce {
    source = ./hypr.conf;
      force = true;
      mutable = true;
    };
    # Waybar
    ".config/waybar/config.jsonc" = pkgs.lib.mkForce {
    source = ./waybar.jsonc;
      force = true;
      mutable = true;
    };
    # HyDE
    ".config/hyde/config.toml" = pkgs.lib.mkForce {
    source = ./hyde.toml;
      force = true;
      mutable = true;
    };
    # Override HyDE's AMD helper to remove the pyamdgpuinfo dependency and use sysfs fallback
    ".local/lib/hyde/amdgpu.py" = pkgs.lib.mkForce {
      source = ./amdgpu.py;
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
    # Gaming
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "\${HOME}/.steam/root/compatibilitytools.d";
    STEAMLIBRARY = "\${HOME}/.steam/steam";
    PROTON_EXPERIMENTAL =
      "\${HOME}/.local/share/Steam/steamapps/common/Proton - Experimental";
    PROTON_GE = "\${STEAM_EXTRA_COMPAT_TOOLS_PATHS}/Proton-GE";
    PROTON = "\${PROTON_EXPERIMENTAL}";
    # Other variables
    # NIX_BUILD_SHELL = "fish";
    GOPATH = "\${HOME}/go";
  };

  home.sessionPath = [
    "\${HOME}/go/bin"
  ];
}
