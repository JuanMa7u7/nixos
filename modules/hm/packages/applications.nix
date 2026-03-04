{ pkgs, inputs, lib, ... }:
let
  system = "x86_64-linux";
  gpartedWrapper = pkgs.writeShellScriptBin "gparted" ''
    exec pkexec --disable-internal-agent \
      env \
      DISPLAY="$DISPLAY" \
      XAUTHORITY="''${XAUTHORITY:-$HOME/.Xauthority}" \
      GDK_BACKEND=x11 \
      WAYLAND_DISPLAY= \
      "${pkgs.gparted-full}/libexec/gpartedbin" "$@"
  '';
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
    (lib.hiPrio gpartedWrapper)
  ];

  xdg.desktopEntries.gparted = {
    name = "GParted";
    genericName = "Partition Editor";
    comment = "Create, reorganize, and delete partitions";
    exec = "gparted %f";
    icon = "gparted";
    terminal = false;
    categories = [
      "GNOME"
      "System"
      "Filesystem"
    ];
  };
}
