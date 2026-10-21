{ lib, pkgs, ... }:

let
  pname = "quiver-launcher";
  version = "3.5.1";

  src = pkgs.fetchurl {
    url = "https://github.com/tgeorgiadis/quiver-launcher/releases/download/v${version}/QuiverLauncher-linux-x64.AppImage";
    hash = "sha256:a8cd5398b6dae924bcec09ece1781c03cbfd73298675476f26fc1c072d3c629b";
  };

  icon = pkgs.fetchurl {
    url = "https://quiverlauncher.com/quiver-icon-96.png";
    hash = "sha256:0l0mrpcncxaj6h9m9libgl6s6zjk4nzkigx4rbybd46q798plbq2";
  };

  quiverLauncher = pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraPkgs = pkgs: [ pkgs.icu ];

    extraInstallCommands = ''
      if [ -e "$out/bin/${pname}-${version}" ]; then
        mv "$out/bin/${pname}-${version}" "$out/bin/${pname}"
      fi

      install -Dm644 ${icon} "$out/share/icons/hicolor/96x96/apps/${pname}.png"
    '';

    meta = with lib; {
      description = "Quiver Launcher";
      homepage = "https://quiverlauncher.com/";
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      platforms = [ "x86_64-linux" ];
      mainProgram = pname;
    };
  };
in
{
  home.packages = [ quiverLauncher ];

  xdg.desktopEntries.quiver-launcher = {
    name = "Quiver Launcher";
    comment = "Quiver Launcher";
    exec = "${quiverLauncher}/bin/${pname}";
    icon = pname;
    terminal = false;
    type = "Application";
    categories = [
      "Game"
      "Utility"
    ];
    startupNotify = true;
  };
}
