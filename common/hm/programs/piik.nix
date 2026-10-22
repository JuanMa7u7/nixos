{ pkgs, ... }:

let
  piik = pkgs.callPackage ../../../packages/piik { };
in
{
  home.packages = [ piik ];

  xdg.desktopEntries.piik = {
    name = "Piik";
    comment = "Private screen sharing for friends";
    exec = "${piik}/bin/piik-app";
    icon = "piik";
    terminal = true;
    type = "Application";
    categories = [
      "Network"
      "Utility"
    ];
    startupNotify = true;
  };
}
