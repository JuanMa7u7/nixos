{ lib, pkgs, ... }:

let
  pname = "comfyui";
  version = "1.1.7";

  src = pkgs.fetchurl {
    url = "https://dl.todesktop.com/241130tqe9q3y/versions/${version}/linux/appimage";
    hash = "sha256-hfymSmZ2TERdM1xMJbbkS3gaZ1oAr5rpW46wJoOaQGI=";
  };

  icon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Comfy-Org/Comfy-Desktop/v${version}/assets/Comfy_Logo_x512.png";
    hash = "sha256-KgOWK/qRS+KXh6UZ2ibBRfQ67DSe0eEeSu79K0L6b/s=";
  };

  comfyui = pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      if [ -e "$out/bin/${pname}-${version}" ]; then
        mv "$out/bin/${pname}-${version}" "$out/bin/${pname}"
      fi

      install -Dm644 ${icon} "$out/share/icons/hicolor/512x512/apps/${pname}.png"
    '';

    meta = with lib; {
      description = "Desktop application for installing, managing, and running ComfyUI";
      homepage = "https://github.com/Comfy-Org/Comfy-Desktop";
      license = licenses.agpl3Plus;
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      platforms = [ "x86_64-linux" ];
      mainProgram = pname;
    };
  };
in
{
  home.packages = [ comfyui ];

  xdg.desktopEntries.comfyui = {
    name = "Comfy Desktop";
    comment = "Install, run, and manage ComfyUI";
    exec = "${comfyui}/bin/${pname} --no-sandbox";
    icon = pname;
    terminal = false;
    type = "Application";
    categories = [
      "Graphics"
      "Development"
    ];
    startupNotify = true;
  };
}
