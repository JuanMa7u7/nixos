{ pkgs, inputs, ... }:

{
    home.packages = with pkgs; [
    # ------------------------------- // Gaming
        gamemode
        mangohud
        gamescope
        lutris
        protonup-ng
    ];
}