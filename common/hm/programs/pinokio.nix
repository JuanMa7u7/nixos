{ lib, pkgs, ... }:

let
  pname = "pinokio";
  version = "8.2.0";

  src = pkgs.fetchurl {
    url = "https://github.com/pinokiocomputer/pinokio/releases/download/v${version}/Pinokio-${version}.AppImage";
    hash = "sha256:1060053973697544b23d8dcb55068cafdaa9f8c84f16e07677efa4f4597e9586";
  };

  icon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/pinokiocomputer/pinokio/v${version}/assets/icon.png";
    hash = "sha256-YG+ejOJkeS/cHQUVgeafK4aDzpRU9YkcBaQrq7/YUDU=";
  };

  pinokio = pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      if [ -e "$out/bin/${pname}-${version}" ]; then
        mv "$out/bin/${pname}-${version}" "$out/bin/${pname}"
      fi

      install -Dm644 ${icon} "$out/share/icons/hicolor/512x512/apps/${pname}.png"
    '';

    meta = with lib; {
      description = "AI browser and one-click open-source application launcher";
      homepage = "https://pinokio.co/";
      license = licenses.mit;
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      platforms = [ "x86_64-linux" ];
      mainProgram = pname;
    };
  };

  wrapper = pkgs.writeShellScriptBin "pinokio-wrapper" ''
    export ELECTRON_OZONE_PLATFORM_HINT=x11
    export ELECTRON_DISABLE_GPU=1
    exec ${pinokio}/bin/${pname} --ozone-platform=x11 --disable-gpu --disable-gpu-sandbox "$@"
  '';
in
{
  home.packages = [ pinokio wrapper ];

  xdg.desktopEntries.pinokio = {
    name = "Pinokio";
    comment = "AI browser and one-click open-source application launcher";
    exec = "${wrapper}/bin/pinokio-wrapper";
    icon = pname;
    terminal = false;
    type = "Application";
    categories = [
      "Development"
      "Utility"
    ];
    startupNotify = true;
  };
}
