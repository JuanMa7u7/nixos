{ pkgs, ... }:
{
    home.packages = with pkgs; [
    # ------------------------------- // Gaming
        gamemode
        gamescope
        lutris
        mangohud
        protontricks
        protonup-ng
        steam-run
        vulkan-tools
        winetricks
        protonup-qt
        mangohud
        mangojuice
        openrgb-with-all-plugins
        lsfg-vk
        piper
        libratbag
    ];
}
