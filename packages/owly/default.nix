{
  autoPatchelfHook,
  fetchurl,
  gnutar,
  lib,
  python3,
  stdenv,
}:

let
  pname = "owly";
  version = "0.4.0";

  src = fetchurl {
    url = "https://github.com/t4t5/owly/releases/download/v${version}/omdrop-owl-${version}-x86_64.tar.gz";
    hash = "sha256:229617d237c207c7d70ec49dd76caf34859c07960beafecfc585f71d07f6cc59";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  dontUnpack = true;

  nativeBuildInputs = [
    autoPatchelfHook
    gnutar
    python3
  ];

  buildInputs = [ stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$TMPDIR/unpacked"
    tar --extract --gzip --file="$src" --directory="$TMPDIR/unpacked" --strip-components=1

    mkdir -p "$out/bin" "$out/lib" "$out/share"
    install -Dm755 "$TMPDIR/unpacked/usr/bin/owly" "$out/bin/owly"
    cp -a "$TMPDIR/unpacked/usr/lib/." "$out/lib/"
    cp -a "$TMPDIR/unpacked/usr/share/." "$out/share/"

    # These paths are fixed by Omdrop's radio hook interface.
    for hook in probe up tick down peers; do
      ln -sfn "$out/lib/omdrop-owl/omdrop-owl" "$out/lib/omdrop/radio/$hook"
    done

    ln -s "$out/lib/omdrop-owl/omdrop-owl" "$out/bin/omdrop-owl"

    substituteInPlace "$out/lib/systemd/system/owlyd.service" \
      --replace-fail /usr/lib/owly/owlyd "$out/lib/owly/owlyd"

    substituteInPlace "$out/lib/omdrop/omdrop-discoverable" \
      --replace-fail /usr/lib/omdrop-owl/omdrop-owl "$out/lib/omdrop-owl/omdrop-owl"

    substituteInPlace "$out/share/polkit-1/actions/io.github.t4t5.omdrop-owl.policy" \
      --replace-fail /usr/lib/omdrop/omdrop-discoverable "$out/lib/omdrop/omdrop-discoverable"

    patchShebangs "$out/lib/omdrop"

    runHook postInstall
  '';

  meta = with lib; {
    description = "AirDrop's Wi-Fi radio and Linux integration for nearby Apple devices";
    homepage = "https://github.com/t4t5/owly";
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "owly";
  };
}
