{ pkgs, pkgs-edge, ... }:
let
  stablePkgs = with pkgs; [
    cava
    (mpv.override { scripts = [ mpvScripts.mpris ]; })
    helvum
    easyeffects
    qjackctl
    rtaudio
    gimp3-with-plugins
    gnome-network-displays
    miraclecast
    nwg-look
    vlc
  ];
  edgePkgs = with pkgs-edge; [
  ];
in
{
  home.packages = stablePkgs ++ edgePkgs;
}
