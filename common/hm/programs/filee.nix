{ config, lib, pkgs, ... }:

let
  pname = "filee";
  version = "2.0.0";

  archive = pkgs.fetchurl {
    url = "https://github.com/KnifeLemon/Filee/releases/download/v${version}/Filee-${version}-linux-x64.tar.gz";
    hash = "sha256:e34a6f9464fac3af74dd646af54d7a75cffacb064fbe11d98701a874e68a170a";
  };

  src = pkgs.runCommand "${pname}-${version}-unpacked" {
    nativeBuildInputs = [ pkgs.gnutar ];
  } ''
    mkdir -p "$out"
    tar --extract --gzip --file=${archive} --directory="$out" --strip-components=1
  '';

  icon = pkgs.writeText "filee.svg" ''
    <svg class="logo" viewBox="0 0 512 512" aria-hidden="true"><path fill="#7F77DD" d="M154.61 65.27A216 216 0 0 1 357.39 65.27L304.82 164.17A104 104 0 0 0 207.18 164.17Z"></path><path transform="translate(13.86,-8)" fill="#1D9E75" d="M373.66 67.74A222 222 0 0 1 477.86 248.23L359.94 252.36A104 104 0 0 0 311.12 167.81Z"></path><path fill="#7F77DD" d="M471.87 263.56A216 216 0 0 1 370.48 439.17L311.12 344.19A104 104 0 0 0 359.94 259.64Z"></path><path fill="#6A62C9" d="M357.39 446.73A216 216 0 0 1 154.61 446.73L207.18 347.83A104 104 0 0 0 304.82 347.83Z"></path><path fill="#7F77DD" d="M141.52 439.17A216 216 0 0 1 40.13 263.56L152.06 259.64A104 104 0 0 0 200.88 344.19Z"></path><path fill="#6A62C9" d="M40.13 248.44A216 216 0 0 1 141.52 72.83L200.88 167.81A104 104 0 0 0 152.06 252.36Z"></path><path fill="#3C3489" d="M222 212h44l24 24v64h-68z"></path><path fill="#AFA9EC" d="M266 212v24h24z"></path></svg>
  '';

  runtimeLibs = with pkgs; [
    fontconfig
    freetype
    icu
    libdrm
    libglvnd
    libice
    libudev0-shim
    libsm
    libx11
    libxcursor
    libxext
    libxfixes
    libxi
    libxinerama
    libxkbcommon
    libxrandr
    libxrender
    openssl
    libxcb
    stdenv.cc.cc.lib
    wayland
  ];

  libPath = lib.makeLibraryPath runtimeLibs;

  guiRuntime = pkgs.writeShellScriptBin "filee-app-runtime" ''
    export LD_LIBRARY_PATH="${src}:${libPath}:''${LD_LIBRARY_PATH:-}"
    exec "${src}/Filee" "$@"
  '';

  # The bundled SkiaSharp no-dependencies build scans /usr/share/fonts directly.
  guiFhs = pkgs.buildFHSEnv {
    name = "${pname}-gui-fhs";
    targetPkgs = pkgs': runtimeLibs ++ [ pkgs'.dejavu_fonts ];
    runScript = "${guiRuntime}/bin/filee-app-runtime";
  };

  gui = pkgs.writeShellScriptBin "filee-app" ''
    exec "${guiFhs}/bin/${guiFhs.name}" "$@"
  '';

  cli = pkgs.writeShellScriptBin pname ''
    export LD_LIBRARY_PATH="${src}:${libPath}:''${LD_LIBRARY_PATH:-}"
    exec "${src}/filee-cli" "$@"
  '';

  filee = pkgs.symlinkJoin {
    name = "${pname}-${version}";
    paths = [ gui cli ];
    postBuild = ''
      install -Dm644 ${icon} "$out/share/icons/hicolor/scalable/apps/${pname}.svg"
    '';

    meta = with lib; {
      description = "Offline file converter with drag-and-drop and command-line interfaces";
      homepage = "https://github.com/KnifeLemon/Filee";
      license = licenses.mit;
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      platforms = [ "x86_64-linux" ];
      mainProgram = pname;
    };
  };

  autostartEntry = pkgs.writeText "filee-nix-autostart.desktop" ''
    [Desktop Entry]
    Type=Application
    Name=Filee
    Exec=${filee}/bin/filee-app --start-with-system=off --background
    Icon=${pname}
    Terminal=false
    X-GNOME-Autostart-enabled=true
  '';
in
{
  home.packages = [ filee ];

  xdg.autostart = {
    enable = true;
    entries = [ autostartEntry ];
  };

  home.activation.removeLegacyFileeAutostart = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    legacyAutostart="${config.xdg.configHome}/autostart/filee.desktop"
    if [ -f "$legacyAutostart" ] && ${pkgs.gnugrep}/bin/grep -Eq '^Exec="[^"]*/Filee" --background$' "$legacyAutostart"; then
      $DRY_RUN_CMD rm -f "$legacyAutostart"
    fi
  '';

  xdg.desktopEntries.filee = {
    name = "Filee";
    comment = "Convert files with Filee";
    exec = "${filee}/bin/filee-app --convert %F";
    icon = pname;
    terminal = false;
    type = "Application";
    categories = [ "Utility" ];
    startupNotify = true;
  };
}
