{
  inputs,
  lib,
  pkgs,
  ...
}: let
  src = inputs.xodus;

  xodus = pkgs.rustPlatform.buildRustPackage {
    pname = "xodus";
    version = "b3d7fb21";

    inherit src;

    cargoLock = {
      lockFile = "${src}/Cargo.lock";
      outputHashes = {
        "ntfs-0.4.0" = "sha256-hhVOmVnvg5aW+KIU1y/ipYSWRyxb+CC8QbTMiQ/fs68=";
        "xal-0.1.3" = "sha256-7pwEHTw2DMK3UNBvS7VYzWubsIHmSa7ljz8IPZWXi1k=";
      };
    };

    nativeBuildInputs = [
      pkgs.protobuf
      pkgs.pkg-config
    ];

    buildInputs = [
      pkgs.webkitgtk_4_1
      pkgs.openssl
    ];

    doCheck = false;

    meta = with lib; {
      description = "Xbox PC game migration to Linux — login, download, license, and decrypt only (game launching not yet supported)";
      homepage = "https://github.com/xodus-gaming/xodus";
      license = licenses.gpl3Only;
      platforms = ["x86_64-linux"];
      mainProgram = "xodus-cli";
    };
  };

  icon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/xodus-gaming/xodus/${src.rev}/assets/Icon/Icon.ico";
    hash = "sha256-masFKpV/+mYAInGspOjh6A0Pn6+5Fwo9u/CPDc4Yvvs=";
  };

  launcher = pkgs.writeShellApplication {
    name = "xodus-launcher";
    runtimeInputs = [xodus];
    text = ''
      set -euo pipefail

      xodus-service &>/dev/null &
      SERVICE_PID=$!

      cleanup() {
        kill "$SERVICE_PID" 2>/dev/null || true
      }
      trap cleanup EXIT

      exec xodus-cli "$@"
    '';
  };
in {
  home.packages = [xodus launcher];

  xdg.desktopEntries.xodus = {
    name = "Xodus";
    comment = "Xbox PC games on Linux — login, download, license, decrypt";
    exec = "${lib.getExe launcher}";
    icon = "${icon}";
    terminal = false;
    type = "Application";
    categories = [
      "Game"
      "Utility"
    ];
    startupNotify = true;
  };
}
