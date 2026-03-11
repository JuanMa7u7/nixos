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
    gthumb
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

      "image/jpeg" = [ "gthumb.desktop" ];
      "image/png" = [ "gthumb.desktop" ];
      "image/gif" = [ "gthumb.desktop" ];
      "image/bmp" = [ "gthumb.desktop" ];
      "image/tiff" = [ "gthumb.desktop" ];
      "image/x-bmp" = [ "gthumb.desktop" ];
      "image/x-ico" = [ "gthumb.desktop" ];
      "image/x-png" = [ "gthumb.desktop" ];
      "image/x-tga" = [ "gthumb.desktop" ];
      "image/x-tiff" = [ "gthumb.desktop" ];
      "image/x-webp" = [ "gthumb.desktop" ];
      "image/webp" = [ "gthumb.desktop" ];
      "image/svg+xml" = [ "gthumb.desktop" ];
      
      "application/javascript" = "nvim.desktop";
      "application/json" = "nvim.desktop";
      "application/x-shellscript" = "nvim.desktop";
      "application/xml" = "nvim.desktop";
      "inode/directory" = "org.kde.dolphin.desktop";
      "text/css" = "nvim.desktop";
      "text/markdown" = "nvim.desktop";
      "text/plain" = "nvim.desktop";
      "text/x-c++src" = "nvim.desktop";
      "text/x-csrc" = "nvim.desktop";
      "text/x-go" = "nvim.desktop";
      "text/x-java-source" = "nvim.desktop";
      "text/x-python" = "nvim.desktop";
      "text/x-typescript" = "nvim.desktop";
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
