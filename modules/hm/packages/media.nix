{ pkgs, inputs, ... }:

{
    home.packages = with pkgs; [
        gimp3-with-plugins
        gnome-network-displays
        miraclecast
        nwg-look
    # ------------------------------- // Music    
       
    ];
}