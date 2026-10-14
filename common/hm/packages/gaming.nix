{ pkgs, pkgs-edge, inputs, ... }:
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
    # bottles  # temporarily disabled - patool test issue
    prismlauncher
    dolphin-emu
    # pcsx2  # temporarily disabled - FFmpeg API build failure
    # rpcs3  # temporarily disabled - FFmpeg API build failure
    # shadps4
    inputs.trinity-launcher.packages.${pkgs.system}.default
    lsfg-vk
    lsfg-vk-ui
  ];
  edgePkgs = with pkgs-edge; [
  ];
in
{
  home.packages = stablePkgs ++ edgePkgs;
}
