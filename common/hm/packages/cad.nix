{ pkgs, lib, ... }:
let
  # OrcaSlicer crashes twice on this setup (Hyprland/Wayland + NVIDIA):
  #  1. "Gdk-Message: Error 71 (Protocol error) dispatching to Wayland
  #     display." Global Hyprland env sets GDK_BACKEND=wayland,x11 (see
  #     common/hm/confs/hypr/hyprland/env.conf), so Orca tries Wayland first.
  #     Force XWayland + disable WebKit dmabuf/compositing (avoids GBM buffer
  #     failures on NVIDIA).
  #  2. "free(): invalid size" (SIGABRT in std::locale::_Impl::~_Impl via
  #     bundled libbambu_networking) when running under en_US.UTF-8.
  #     LC_ALL=C sidesteps the crashing locale-destructor path (verified:
  #     crashes without it, stays up with it) and keeps dot decimals.
  # hiPrio wrapper shadows pkgs.orca-slicer in PATH, so both terminal and
  # the shipped com.orcaslicer.OrcaSlicer.desktop (Exec=orca-slicer %U)
  # pick up the fix.
  orcaSlicerWrapper = pkgs.writeShellScriptBin "orca-slicer" ''
    export GDK_BACKEND=x11
    export WEBKIT_DISABLE_DMABUF_RENDERER=1
    export WEBKIT_DISABLE_COMPOSITING_MODE=1
    export LC_ALL=C
    exec ${pkgs.orca-slicer}/bin/orca-slicer "$@"
  '';
in
{
  home.packages = with pkgs; [
    blender
    cura-appimage
    orca-slicer
  ] ++ [
    (lib.hiPrio orcaSlicerWrapper)
  ];
}
