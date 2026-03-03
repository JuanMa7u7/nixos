{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gamemode
    gamescope
    lutris
    mangohud
    protontricks
    protonup-ng
    steam-run
    vulkan-tools
    winetricks
  ];
}
