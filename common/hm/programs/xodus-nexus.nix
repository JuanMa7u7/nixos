{ lib, pkgs, ... }:

let
  pname = "xodus-nexus";
  version = "0.4.1";

  src = pkgs.fetchurl {
    url = "https://github.com/domsvoboda/xodus-nexus/releases/download/v${version}/Xodus-Nexus-${version}-x86_64.AppImage";
    hash = "sha256:3ba5cce6a3d84bec3d7b2286cf878886f0b8dd3a6aea7635abe376a0237dbd4d";
  };

  icon = pkgs.fetchurl {
    url = "https://github.com/domsvoboda/xodus-nexus/raw/main/assets/icon.png";
    hash = "sha256:4a704edafef74b5f4fdcf1d27647e54bd8045874e57b01b592b3b3ffc6dfae34";
  };

  xodusNexus = pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    multiArch = true;

    extraPkgs = pkgs: with pkgs; [ 
      libsecret
      gnutls
      libgcrypt
      libgpg-error
      nss
      nspr
      p11-kit
      libtasn1
      nettle
      libunistring
      libidn2
      gmp
      zlib
      openssl
      cacert
      glib-networking
      libsoup_3
      sqlite
      icu
      libffi
      libusb1
      systemd
      libudev0-shim
      libx11
      libxcursor
      libxi
      libxrandr
      libxinerama
      libxscrnsaver
      libxtst
      libxcomposite
      libxdamage
      libxfixes
      libxrender
      libxcb
      libxkbcommon
      wayland
      libglvnd
      mesa
      vulkan-loader
      alsa-lib
      libpulseaudio
      pipewire
      gtk3
      gdk-pixbuf
      glib
      pango
      cairo
      dbus
      krb5
      freetype
      fontconfig
      expat
    ] ++ (with pkgs.pkgsi686Linux; [ 
      gnutls
      libgcrypt
      libgpg-error
      nss
      nspr
      p11-kit
      libtasn1
      nettle
      libunistring
      libidn2
      gmp
      zlib
      openssl
      glib-networking
      libsoup_3
      sqlite
      icu
      libffi
      libusb1
      libudev0-shim
      libx11
      libxcursor
      libxi
      libxrandr
      libxinerama
      libxscrnsaver
      libxtst
      libxcomposite
      libxdamage
      libxfixes
      libxrender
      libxcb
      libxkbcommon
      libglvnd
      mesa
      vulkan-loader
      alsa-lib
      libpulseaudio
      gtk3
      gdk-pixbuf
      glib
      pango
      cairo
      dbus
      krb5
      freetype
      fontconfig
      expat
    ]);
    extraInstallCommands = ''
      if [ -e "$out/bin/${pname}-${version}" ]; then
        mv "$out/bin/${pname}-${version}" "$out/bin/${pname}"
      fi

      install -Dm644 ${icon} "$out/share/icons/hicolor/512x512/apps/${pname}.png"
    '';

    meta = with lib; {
      description = "Open-source Xbox-inspired desktop launcher for Xodus on Linux";
      homepage = "https://github.com/domsvoboda/xodus-nexus";
      license = licenses.mit;
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      platforms = [ "x86_64-linux" ];
      mainProgram = pname;
    };
  };

  wrapper = pkgs.writeShellScriptBin "xodus-nexus-wrapper" ''
    export ELECTRON_DISABLE_SANDBOX=1
    export WINEESYNC=0
    export WINEFSYNC=0
    export PROTON_NO_ESYNC=1
    export PROTON_NO_FSYNC=1
    export SDL_VIDEODRIVER=wayland,x11
    exec ${xodusNexus}/bin/${pname} --no-sandbox "$@"
  '';
in
{
  home.packages = [ xodusNexus wrapper ];

  xdg.desktopEntries.xodus-nexus = {
    name = "Xodus Nexus";
    comment = "Xbox-inspired desktop launcher for Xodus";
    exec = "${wrapper}/bin/xodus-nexus-wrapper";
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
