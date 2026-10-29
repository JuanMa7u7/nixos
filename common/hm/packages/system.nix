{ pkgs, pkgs-edge, inputs, lib, ... }:
let
  system = "x86_64-linux";

  gpartedWrapper = pkgs.writeShellScriptBin "gparted" ''
    exec pkexec --disable-internal-agent \
      env \
      DISPLAY="$DISPLAY" \
      XAUTHORITY="${XAUTHORITY:-$HOME/.Xauthority}" \
      GDK_BACKEND=x11 \
      WAYLAND_DISPLAY= \
      "${pkgs.gparted-full}/libexec/gpartedbin" "$@"
  '';
in
{
  home.packages = with pkgs; [
    file # QuickShell uses this to read downloaded floating-image dimensions.
    gnome-disk-utility
    x11vnc
    ktailctl
  ] ++ [
    (lib.hiPrio gpartedWrapper)
  ];
}
