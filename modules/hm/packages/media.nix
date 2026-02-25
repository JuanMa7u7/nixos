{ pkgs, inputs, ... }:

{
    home.packages = with pkgs; [
        gimp3-with-plugins
        gnome-network-displays
        miraclecast
    # ------------------------------- // Music    
       
    ];
}