{ lib, pkgs, ... }:

let
  pname = "motrix";
  version = "2.0.0-beta.52";

  src = pkgs.fetchurl {
    url = "https://github.com/agalwood/Motrix/releases/download/v${version}/Motrix-${version}-x86_64.AppImage";
    hash = "sha256:b5c4ffde5367bc6d63e22da2b6696c4366f3fd37848b30f1b7b91751962be54b";
  };

  icon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/agalwood/Motrix/v${version}/public/app-icon.png";
    hash = "sha256-BE07ZKFKpRLKQUaTctGtYwVX2q6yy05wnTTy08V9TDs=";
  };

  motrix = pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      if [ -e "$out/bin/${pname}-${version}" ]; then
        mv "$out/bin/${pname}-${version}" "$out/bin/${pname}"
      fi

      install -Dm644 ${icon} "$out/share/icons/hicolor/512x512/apps/${pname}.png"
    '';

    meta = with lib; {
      description = "Full-featured download manager for HTTP, FTP, BitTorrent, and magnet links";
      homepage = "https://github.com/agalwood/Motrix";
      license = licenses.mit;
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      platforms = [ "x86_64-linux" ];
      mainProgram = pname;
    };
  };
in
{
  home.packages = [ motrix ];

  xdg.desktopEntries.motrix = {
    name = "Motrix";
    comment = "Download manager for HTTP, FTP, BitTorrent, and magnet links";
    exec = "${motrix}/bin/${pname}";
    icon = pname;
    terminal = false;
    type = "Application";
    categories = [
      "Network"
      "FileTransfer"
    ];
    startupNotify = true;
  };
}
