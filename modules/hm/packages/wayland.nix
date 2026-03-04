{ pkgs, ... }:
{
  home.packages = with pkgs; [
    polkit_gnome
    xorg.xhost
    wlsunset
  ];
}
