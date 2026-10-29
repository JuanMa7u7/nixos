{ lib, pkgs, ... }:

let
  pname = "pencil";
  version = "1.2.21";

  # Keep the version, release URL, and fixed hash in sync when updating this AppImage.
  src = pkgs.fetchurl {
    url = "https://github.com/highagency/pen-desktop-releases/releases/download/v1.2.21/Pen-1.2.21-linux-x86_64.AppImage";
    hash = "sha256-CdRsvJiafAR+WBsRV/NFlMQt2tN6xnFEnRK1/ZjNY1M=";
  };

  appimageContents = pkgs.appimageTools.extractType2 {
    inherit pname version src;
  };

  pencil = pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      if [ -e "$out/bin/${pname}-${version}" ]; then
        mv "$out/bin/${pname}-${version}" "$out/bin/${pname}"
      fi

      install -Dm644 ${appimageContents}/pen.png "$out/share/icons/hicolor/512x512/apps/pen.png"
    '';

    meta = with lib; {
      description = "Desktop app for Pen";
      homepage = "https://www.pen.dev/";
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      platforms = [ "x86_64-linux" ];
      mainProgram = pname;
    };
  };
in
{
  home.packages = [ pencil ];

  xdg.desktopEntries.pencil = {
    name = "Pen";
    comment = "Desktop app for Pen";
    exec = "${lib.getExe pencil} --no-sandbox %U";
    icon = "pen";
    terminal = false;
    type = "Application";
    categories = [
      "Graphics"
    ];
    mimeType = [
      "x-scheme-handler/pencil"
    ];
    startupNotify = true;
    settings = {
      StartupWMClass = "Pen";
    };
  };
}
