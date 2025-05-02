{ pkgs, inputs, ... }:

{
    home.packages = with pkgs; [
        wlsunset
    ];
}