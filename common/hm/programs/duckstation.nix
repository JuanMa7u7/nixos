{ lib, pkgs, ... }:

let
  pname = "duckstation";
  version = "0.1-11295";

  src = pkgs.fetchurl {
    url = "https://github.com/stenzek/duckstation/releases/download/v${version}/DuckStation-x64.AppImage";
    hash = "sha256:b35fc76bb3cace5278aff1993593eed3cef21c960c33a5d95aee5251126e87e1";
  };

  icon = pkgs.fetchurl {
    url = "https://duckstation.org/assets/img/duck.svg";
    hash = "sha256:65c07f0b93b9be9fb5469f37119cfa39e193c5b3da438e7c3b47d37bc7e637c0";
  };

  duckstation = pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      if [ -e "$out/bin/${pname}-${version}" ]; then
        mv "$out/bin/${pname}-${version}" "$out/bin/${pname}"
      fi

      install -Dm644 ${icon} "$out/share/icons/hicolor/scalable/apps/${pname}.svg"
    '';

    meta = with lib; {
      description = "PS1 Emulator";
      homepage = "https://duckstation.org/";
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      platforms = [ "x86_64-linux" ];
      mainProgram = pname;
    };
  };

  wrapper = pkgs.writeShellScriptBin "duckstation-wrapper" ''
    export QT_QPA_PLATFORM=xcb
    export SDL_VIDEODRIVER=x11
    export DSM_USEGAMEPATH=0
    exec ${duckstation}/bin/duckstation "$@"
  '';
in
{
  home.packages = [ duckstation wrapper ];

  xdg.desktopEntries.duckstation = {
    name = "DuckStation";
    comment = "PS1 Emulator";
    exec = "${wrapper}/bin/duckstation-wrapper";
    icon = "duckstation";
    terminal = false;
    type = "Application";
    categories = [
      "Game"
      "Utility"
    ];
    startupNotify = true;
  };
}