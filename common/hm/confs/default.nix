{ lib, ... }:
{
  # Hyprland configuration is owned by illogical-flake's activation copy of
  # dots/.config/hypr (hyprland.lua + custom/); shared and per-host fragments
  # live in common/hm/*.lua and hosts/<host>/hm/host/*.lua. Do not add
  # home.file entries under .config/hypr here: copyIllogicalImpulseConfigs
  # replaces that tree on every switch.
  home.file = {
    ".config/zen" = {
      source = ./zen;
      recursive = true;
    };

    ".config/btop" = {
      source = ./btop;
      recursive = true;
    };

    ".config/fastfetch" = {
      source = ./fastfetch;
      recursive = true;
    };

    # opencode global config — versioned, deployed as individual files so
    # plugin-managed state (node_modules, secrets, notifier state) stays
    # unmanaged in ~/.config/opencode.
    ".config/opencode/opencode.jsonc".source = ./opencode/opencode.jsonc;
    ".config/opencode/AGENTS.md".source = ./opencode/AGENTS.md;
  };

  home.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = "1";
    NIXPKGS_ALLOW_INSECURE = "1";
    XCURSOR_SIZE = "26";
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    STEAMLIBRARY = lib.mkDefault "\${HOME}/.steam/steam";
    PROTON_EXPERIMENTAL = "\${HOME}/.local/share/Steam/steamapps/common/Proton - Experimental";
    PROTON_GE = "\${STEAM_EXTRA_COMPAT_TOOLS_PATHS}/Proton-GE";
    PROTON = "\${PROTON_EXPERIMENTAL}";
    GOPATH = "\${HOME}/go";
    NPM_CONFIG_PREFIX = "\${HOME}/.local/share/npm";
  };

  home.sessionPath = [
    "\${HOME}/go/bin"
    "\${HOME}/.local/share/npm/bin"
  ];
}
