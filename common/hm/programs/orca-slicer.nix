{ lib, pkgs, ... }:

let
  # The Nixpkgs source build can statically link a second libstdc++, causing
  # `free(): invalid size` when the Bambu networking plugin loads.
  pname = "orca-slicer";
  version = "2.5.0-beta";

  src = pkgs.fetchurl {
    url = "https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v${version}/OrcaSlicer_Linux_AppImage_Ubuntu2404_V${version}.AppImage";
    hash = "sha256:15b0e9f9d577bc7a84cfef4f1ecc6e16ef75bc253e500d772fcaa66f4c25b97e";
  };

  icon = pkgs.fetchurl {
    url = "https://github.com/OrcaSlicer/OrcaSlicer/raw/main/resources/images/OrcaSlicer.png";
    hash = "sha256-/PLxGoZIjXU+RS+lqYAMRVGQm/T7EnZfp0/j97ZDgwg=";
  };

  orcaSlicerAppImage = pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraPkgs = pkgs: with pkgs; [
      gtk3
      glib-networking
      libsecret
      vulkan-loader
      webkitgtk_4_1
      libsoup_3
      stdenv.cc.cc.lib
    ];

    extraInstallCommands = ''
      if [ -e "$out/bin/${pname}-${version}" ]; then
        mv "$out/bin/${pname}-${version}" "$out/bin/${pname}"
      fi

      install -Dm644 ${icon} "$out/share/pixmaps/${pname}.png"
    '';

    meta = with lib; {
      description = "G-code generator for 3D printers";
      homepage = "https://github.com/OrcaSlicer/OrcaSlicer";
      license = licenses.agpl3Only;
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      platforms = [ "x86_64-linux" ];
      mainProgram = pname;
    };
  };

  orcaSlicerLauncher = pkgs.writeShellScriptBin pname ''
    export GDK_BACKEND=x11
    export WEBKIT_DISABLE_DMABUF_RENDERER=1
    export WEBKIT_DISABLE_COMPOSITING_MODE=1
    export GIO_EXTRA_MODULES=${pkgs.glib-networking}/lib/gio/modules
    export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
    export LC_ALL=C
    exec ${orcaSlicerAppImage}/bin/${pname} "$@"
  '';
in
{
  home.packages = [
    orcaSlicerAppImage
    (lib.hiPrio orcaSlicerLauncher)
  ];

  xdg.desktopEntries."com.orcaslicer.OrcaSlicer" = {
    name = "OrcaSlicer";
    genericName = "3D Printing Software";
    comment = "G-code generator for 3D printers";
    exec = "${orcaSlicerLauncher}/bin/${pname} %U";
    icon = "${orcaSlicerAppImage}/share/pixmaps/${pname}.png";
    terminal = false;
    type = "Application";
    categories = [ "Graphics" ];
    mimeType = [
      "application/gcode"
      "application/x-gcode"
      "model/stl"
      "application/sla"
      "application/vnd.ms-3mfdocument"
      "application/3mf"
      "application/x-3mf"
    ];
    startupNotify = true;
  };
}
