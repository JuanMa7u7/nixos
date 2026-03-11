{ pkgs, pkgs-edge, ... }:
let
  stablePkgs = with pkgs; [
    gamemode
    mangohud
    lutris
    sidequest
    android-tools
    protonup-ng
    gamescope
    protontricks
    steam-run
    vulkan-tools
    winetricks
    protonup-qt
    mangojuice
    openrgb-with-all-plugins
    lsfg-vk
    piper
    libratbag
  ];
  edgePkgs = with pkgs-edge; [
  ];
in
{
  home.packages = stablePkgs ++ edgePkgs;
}
