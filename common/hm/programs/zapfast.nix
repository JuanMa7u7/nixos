{ lib, pkgs, ... }:

let
  pname = "zapfast";
  version = "0.21.3";

  src = pkgs.fetchurl {
    url = "https://github.com/crmne/zapfast/releases/download/v${version}/zapfast-${version}-x86_64.AppImage";
    hash = "sha256:8cade319ceed9f1a932fb42e51488aa3840bf12e994e8514e51c9eaddc0a5759";
  };

  icon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/crmne/zapfast/v${version}/docs/assets/images/logo.svg";
    hash = "sha256-TJrA1XbQePMnPYobfr5zwo1kylCDii/CH6Q559y54kI=";
  };

  zapfast = pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraPkgs = pkgs: with pkgs; [
      # libstdc++: NEEDED by the native binary, not part of the AppImage FHS defaults
      stdenv.cc.cc.lib
    ];

    extraInstallCommands = ''
      if [ -e "$out/bin/${pname}-${version}" ]; then
        mv "$out/bin/${pname}-${version}" "$out/bin/${pname}"
      fi

      install -Dm644 ${icon} "$out/share/icons/hicolor/scalable/apps/${pname}.svg"
    '';

    meta = with lib; {
      description = "Lightweight native WhatsApp client for Linux, macOS, and Windows";
      homepage = "https://zapfast.rocks/";
      license = licenses.mit;
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      platforms = [ "x86_64-linux" ];
      mainProgram = pname;
    };
  };
in
{
  home.packages = [ zapfast ];

  xdg.desktopEntries.zapfast = {
    name = "ZapFast";
    genericName = "WhatsApp Client";
    comment = "A native WhatsApp client";
    exec = "${lib.getExe zapfast} %U";
    icon = pname;
    terminal = false;
    type = "Application";
    categories = [
      "Network"
      "InstantMessaging"
      "Chat"
    ];
    mimeType = [
      "x-scheme-handler/whatsapp"
      "x-scheme-handler/wa"
    ];
    startupNotify = true;
    settings = {
      Keywords = "whatsapp;chat;messaging;";
      StartupWMClass = "zapfast";
      SingleMainWindow = "true";
    };
    actions = {
      quit = {
        name = "Quit ZapFast";
        exec = "${lib.getExe zapfast} quit";
      };
    };
  };
}
