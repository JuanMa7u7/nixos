{ lib, pkgs, ... }:

let
  pname = "locally-uncensored";
  version = "3.0.7";

  src = pkgs.fetchurl {
    url = "https://github.com/PurpleDoubleD/locally-uncensored/releases/download/v${version}/Locally.Uncensored_${version}_amd64.AppImage";
    hash = "sha256:05d69afef4eb370e39ad6e5d3a2e1406402be913825e5fa4219b2a33f6f5fcd3";
  };

  icon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/PurpleDoubleD/locally-uncensored/v${version}/src-tauri/icons/128x128.png";
    hash = "sha256-SCmU167aZhYm3YVt7DKpljlw2OtE0gkIp4yl8F4EUUY=";
  };

  locallyUncensored = pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraPkgs = pkgs: with pkgs; [
      gtk3
      libayatana-appindicator
      vulkan-loader
      stdenv.cc.cc.lib
    ];

    extraInstallCommands = ''
      if [ -e "$out/bin/${pname}-${version}" ]; then
        mv "$out/bin/${pname}-${version}" "$out/bin/${pname}"
      fi

      install -Dm644 ${icon} "$out/share/icons/hicolor/128x128/apps/${pname}.png"
    '';

    meta = with lib; {
      description = "Local AI desktop studio for chat, image and video generation, and coding agents";
      homepage = "https://github.com/PurpleDoubleD/locally-uncensored";
      license = licenses.agpl3Only;
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      platforms = [ "x86_64-linux" ];
      mainProgram = pname;
    };
  };
in
{
  home.packages = [ locallyUncensored ];

  xdg.desktopEntries.locally-uncensored = {
    name = "Locally Uncensored";
    comment = "Local AI studio for chat, image and video generation, and coding agents";
    exec = "${locallyUncensored}/bin/${pname}";
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
