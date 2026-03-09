{ lib, pkgs, ... }:
{
  home.file = {
    ".config/hypr/hyprland" = {
      source = ./hypr/hyprland;
      recursive = true;
    };

    ".config/hypr/scripts" = {
      source = ./hypr/scripts;
      recursive = true;
    };

    ".config/hypr/scheme" = {
      source = ./hypr/scheme;
      recursive = true;
    };

    ".config/hypr/hyprland.conf" = {
      source = ./hypr/hyprland.conf;
    };

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

    ".config/hypr/userprefs.conf" = lib.mkForce {
      text = ''
        exec-once = ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
        exec-once = ${pkgs.xhost}/bin/xhost +SI:localuser:root

        source = ~/.config/hypr/hyprland.conf
      '';
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
