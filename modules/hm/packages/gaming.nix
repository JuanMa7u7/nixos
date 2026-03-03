{ pkgs, inputs, ... }:

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
    ];
}
