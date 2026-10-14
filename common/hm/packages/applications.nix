{ pkgs, pkgs-edge, pkgs-locked, lib, ... }:
let
  stablePkgs = with pkgs; [
    yazi
    eza
    karere
    kdePackages.dolphin # end-4's blessed file manager: ships dolphinrc + kdeglobals + kde-material-you-colors integration
    kdePackages.ark # archive manager (mime default for compressed files)
    kdePackages.kalarm
    kdePackages.networkmanager-qt
  ];

  edgePkgs = with pkgs-edge; [
    vesktop
  ];

  lockedPkgs = with pkgs-locked; [
  ];
in
{
  imports = [
    ./mime.nix
  ];

  home.packages = stablePkgs ++ edgePkgs ++ lockedPkgs;
}
