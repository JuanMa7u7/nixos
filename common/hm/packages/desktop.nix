{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rofi
    # capitaine-cursors-themed  # temporarily disabled - HyDE resource 404
    waypaper
    waytrogen
    swww
    pavucontrol
  ];
}
