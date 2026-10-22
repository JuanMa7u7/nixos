{
  autoPatchelfHook,
  fetchurl,
  glib,
  gst_all_1,
  lib,
  libportal,
  makeWrapper,
  stdenv,
  unzip,
}:

let
  pname = "piik";
  version = "2.3.0";

  src = fetchurl {
    url = "https://github.com/TNTcraftHIM/Piik/releases/download/v${version}/piik-app-linux-amd64.zip";
    hash = "sha256:fd54de62ba4bb35f8e3f1c02029f4805886a488c830247bf9668eb823cf87fd5";
  };

  icon = fetchurl {
    url = "https://github.com/TNTcraftHIM/Piik/raw/main/docs/assets/brand-mark.svg";
    hash = "sha256:9a7ea5f01a90d77fa09927d622fb406c4d24a1eaf6dcff588715f2a7cef224fb";
  };

  gstreamerPlugins = with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
  ];

  runtimeLibraries = [
    glib
    libportal
  ]
  ++ gstreamerPlugins;

  pluginPath = lib.makeSearchPath "lib/gstreamer-1.0" gstreamerPlugins;
in
stdenv.mkDerivation {
  inherit pname version src;

  dontUnpack = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    unzip
  ];

  buildInputs = runtimeLibraries;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/libexec/${pname}" "$out/bin"
    unzip -q "$src" -d "$out/libexec/${pname}"

    makeWrapper "$out/libexec/${pname}/piik-app" "$out/bin/piik-app" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibraries}" \
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${pluginPath}"

    install -Dm644 ${icon} "$out/share/icons/hicolor/scalable/apps/${pname}.svg"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Private screen sharing for friends";
    homepage = "https://github.com/TNTcraftHIM/Piik";
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "piik-app";
  };
}
