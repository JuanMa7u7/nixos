{ pkgs, pkgs-edge, ... }:
let
  stablePkgs = with pkgs; [
    wlsunset
    kde-gruvbox
    polkit_gnome
    xhost
  ];
  edgePkgs = with pkgs-edge; [
  ];
in
{
  home.packages = stablePkgs ++ edgePkgs;
}
