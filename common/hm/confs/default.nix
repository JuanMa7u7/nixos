{ lib, ... }:
{
  # NOTE: Caelestia-era Hyprland dotfiles (.config/hypr/hyprland*,
  # userprefs.conf, scheme/, scripts/, caelestia-colors, Wallpapers) were
  # removed with the end-4 migration. Hypr config is owned by illogical-flake's
  # activation copy of dots/.config/hypr (hyprland.lua + custom/); per-host
  # fragments live in hosts/<host>/hm/host.nix. Do NOT re-add home.file
  # entries under .config/hypr here — the upstream activation step
  # (copyIllogicalImpulseConfigs) wipes them on every switch.
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
