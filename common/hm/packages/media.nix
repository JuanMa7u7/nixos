{ pkgs, pkgs-edge, ... }:
let
  stablePkgs = with pkgs; [
    cava
    # (mpv.override { scripts = [ mpvScripts.mpris ]; })
    crosspipe
    easyeffects
    qjackctl
    rtaudio
    gimp3-with-plugins
    gnome-network-displays
    miraclecast
    nwg-look
    # vlc
    mpc-qt
    obs-studio
    # pactl client only (no daemon; pipewire-pulse stays the server).
    # Needed by end-4's record.sh getaudiooutput(); without it wf-recorder
    # gets --audio="" and segfaults (PulseReader::init).
    pulseaudio
    sunvox
    gthumb
    video-downloader
    gpu-screen-recorder
  ];
  edgePkgs = with pkgs-edge; [
  ];
in
{
  home.packages = stablePkgs ++ edgePkgs;
}
