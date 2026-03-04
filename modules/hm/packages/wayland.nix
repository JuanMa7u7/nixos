{ pkgs, ... }:
{
  home.packages = with pkgs; [
    polkit_gnome
    xhost
    wlsunset
  ];
}
