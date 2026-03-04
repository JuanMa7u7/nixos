{ pkgs, inputs, ... }:
let
  system = "x86_64-linux";
in
{
  home.packages = with pkgs; [
    bottles
    brave
    chromium
    cmatrix
    firefox
    google-chrome
    inputs.zen-browser.packages."${system}".default
    ipfetch
    kdePackages.networkmanager-qt
    neofetch
    nyancat
    obs-studio
    obsidian
    onlyoffice-desktopeditors
    pomodoro
    sunvox
    swww
    telegram-desktop
    thunderbird-bin
    transmission_4-gtk
    typora
    vesktop
    wasistlos
    waypaper
    x11vnc
    waytrogen
    cura-appimage
    gparted-full
  ];
}
