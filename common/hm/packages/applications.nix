{ pkgs, pkgs-edge, pkgs-locked, inputs, lib, ... }:
let
  system = "x86_64-linux";

  gpartedWrapper = pkgs.writeShellScriptBin "gparted" ''
    exec pkexec --disable-internal-agent \
      env \
      DISPLAY="$DISPLAY" \
      XAUTHORITY="${XAUTHORITY:-$HOME/.Xauthority}" \
      GDK_BACKEND=x11 \
      WAYLAND_DISPLAY= \
      "${pkgs.gparted-full}/libexec/gpartedbin" "$@"
  '';

  stablePkgs = with pkgs; [
    _1password-cli
    _1password-gui
    yazi
    eza
    kitty
    firefox
    bottles
    brave
    chromium
    google-chrome
    gnome-disk-utility
    cmatrix
    ipfetch
    kdePackages.konsole
    kdePackages.kalarm
    kdePackages.networkmanager-qt
    neofetch
    nyancat
    obsidian
    obs-studio
    onlyoffice-desktopeditors
    pomodoro
    rofi
    sunvox
    typora
    transmission_4-gtk
    libreoffice
    gcalcli
    todoist
    todoist-electron
    signal-desktop
    zoom-us
    zk
    image-roll
    capitaine-cursors-themed
    telegram-desktop
    thunderbird-bin
    wasistlos
    waypaper
    waytrogen
    x11vnc
    swww
    cura-appimage
    ktailctl
    gparted-full
    nvidia-container-toolkit
    nvidia-docker
    # v4l2loopback
  ];

  edgePkgs = with pkgs-edge; [
    vesktop
  ];

  lockedPkgs = with pkgs-locked; [
  ];
in
{
  home.packages = stablePkgs ++ edgePkgs ++ lockedPkgs ++ [
    inputs.zen-browser.packages."${system}".beta
    (lib.hiPrio gpartedWrapper)
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/chrome" = "zen-beta.desktop";
      "text/html" = "zen-beta.desktop";
      "application/x-extension-htm" = "zen-beta.desktop";
      "application/x-extension-html" = "zen-beta.desktop";
      "application/x-extension-shtml" = "zen-beta.desktop";
      "application/xhtml+xml" = "zen-beta.desktop";
      "application/x-extension-xhtml" = "zen-beta.desktop";
      "application/x-extension-xht" = "zen-beta.desktop";

      "image/jpeg" = [ "image-roll.desktop" ];
      "image/jpg" = [ "image-roll.desktop" ];
      "image/png" = [ "image-roll.desktop" ];
      "image/gif" = [ "image-roll.desktop" ];
      "image/bmp" = [ "image-roll.desktop" ];
      "image/tiff" = [ "image-roll.desktop" ];
      "image/x-bmp" = [ "image-roll.desktop" ];
      "image/x-ico" = [ "image-roll.desktop" ];
      "image/x-png" = [ "image-roll.desktop" ];
      "image/x-tga" = [ "image-roll.desktop" ];
      "image/x-tiff" = [ "image-roll.desktop" ];
      "image/x-webp" = [ "image-roll.desktop" ];
      "image/webp" = [ "image-roll.desktop" ];
      "image/svg+xml" = [ "image-roll.desktop" ];
      
      "application/javascript" = "code.desktop";
      "application/json" = "code.desktop";
      "application/x-shellscript" = "code.desktop";
      "application/xml" = "code.desktop";
      "inode/directory" = "org.kde.dolphin.desktop";
      "text/css" = "code.desktop";
      "text/markdown" = "code.desktop";
      "text/plain" = "code.desktop";
      "text/x-c++src" = "code.desktop";
      "text/x-csrc" = "code.desktop";
      "text/x-go" = "code.desktop";
      "text/x-java-source" = "code.desktop";
      "text/x-python" = "code.desktop";
      "text/x-typescript" = "code.desktop";
      "x-scheme-handler/about" = "org.kde.dolphin.desktop";
      "x-scheme-handler/file" = "org.kde.dolphin.desktop";
    };
  };

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
