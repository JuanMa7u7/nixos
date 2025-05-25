{ pkgs, inputs, ... }:
let
    system = "x86_64/linux";
in
{
    home.packages = with pkgs; [
    # ------------------------------- // Applications
        firefox
        bottles
        # inputs.zen-browser.packages."${system}".default
        brave
        chromium
        google-chrome
        vesktop
        pomodoro
        sunvox
        obsidian
        obs-studio
        typora
        transmission_4-gtk
        onlyoffice-desktopeditors
        libsForQt5.networkmanager-qt
        whatsapp-for-linux
        telegram-desktop
        neofetch
    ];
}