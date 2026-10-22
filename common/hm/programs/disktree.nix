{ lib, pkgs, ... }:

let
  pname = "disktree";
  version = "0.11.0";

  runtimeLibraries = with pkgs; [
    libxcb
    libxkbcommon
    stdenv.cc.cc.lib
    vulkan-loader
    wayland
  ];

  disktree = pkgs.stdenv.mkDerivation {
    inherit pname version;

    src = pkgs.fetchurl {
      url = "https://github.com/tobi/disktree/releases/download/v${version}/disktree-${version}-x86_64-linux.tar.gz";
      hash = "sha256:7e75afa2283c8b4f9290d52eadbfc00d9f14c13aed2d224ccdf0f7826fcc05b2";
    };

    nativeBuildInputs = [
      pkgs.autoPatchelfHook
      pkgs.makeWrapper
    ];

    buildInputs = runtimeLibraries;

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      install -Dm755 disktree "$out/libexec/${pname}/${pname}-unwrapped"
      install -Dm644 disktree.svg "$out/share/icons/hicolor/scalable/apps/${pname}.svg"

      makeWrapper "$out/libexec/${pname}/${pname}-unwrapped" "$out/bin/${pname}" \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibraries}"

      runHook postInstall
    '';

    meta = with lib; {
      description = "Disk space treemap for finding and removing what fills a disk";
      homepage = "https://github.com/tobi/disktree";
      license = licenses.mit;
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      platforms = [ "x86_64-linux" ];
      mainProgram = pname;
    };
  };
in
{
  home.packages = [ disktree ];

  xdg.desktopEntries.disktree = {
    name = "Disk Tree";
    genericName = "Disk space treemap";
    comment = "Find what is using a volume, mark what should go, remove it";
    exec = "${disktree}/bin/${pname} %f";
    icon = pname;
    terminal = false;
    type = "Application";
    categories = [
      "System"
      "Filesystem"
    ];
    mimeType = [ "inode/directory" ];
    actions.disk = {
      name = "Scan the whole disk";
      exec = "${disktree}/bin/${pname} --disk";
    };
    startupNotify = true;
    settings = {
      Keywords = "disk;space;usage;du;treemap;cleanup";
      StartupWMClass = pname;
      "X-AppVersion" = version;
    };
  };
}
