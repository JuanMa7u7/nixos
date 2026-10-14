{ lib
, stdenvNoCC
, ffmpeg
, pngquant
, oxipng
, srcVideo
}:
# Original Xbox boot animation as a Plymouth theme.
# Locked spec: 1920x1080 @60fps, full clip 1:1 in order, audio as-is.
# frames are named frame-1.png .. frame-N.png (no zero-padding) because the
# Plymouth script language coerces ints in string concatenation
# ("frame-" + i + ".png", cf. adi1090x rings theme), which avoids any
# padding logic in og-xbox.script.
stdenvNoCC.mkDerivation {
  pname = "og-xbox-plymouth";
  version = "1.0-1080p60";

  inherit srcVideo;

  nativeBuildInputs = [ ffmpeg pngquant oxipng ];

  dontUnpack = true;

  buildPhase = ''
    runHook preBuild

    themeDir="$out/share/plymouth/themes/og-xbox"
    mkdir -p "$themeDir"

    # 1:1 content, full clip: 60fps, 1920x1080, lanczos.
    ffmpeg -v error -i "$srcVideo" \
      -vf 'fps=60,scale=1920:1080:flags=lanczos' \
      "$themeDir/frame-%d.png"

    frameCount=$(ls "$themeDir"/frame-*.png | wc -l)
    echo "extracted $frameCount frames"
    if [ "$frameCount" -lt 500 ]; then
      echo "unexpectedly few frames (expected ~623 for 10.38s @60fps)" >&2
      exit 1
    fi

    # Shrink for initrd: palette quantize (biggest win on black bg),
    # then a fast lossless strip pass. Keeps 60fps, only bytes change.
    # NOTE: per-file loop with || true — pngquant exits 98 on trivial
    # (fully-black) frames, which must not abort the whole build; those
    # frames are already tiny.
    for f in "$themeDir"/frame-*.png; do
      pngquant --quality=65-85 --skip-if-larger --strip --force \
        --ext .png "$f" || true
    done
    oxipng -o 1 --strip all "$themeDir"/frame-*.png || true

    # Audio as-is: full-length original track, no trim. WAV so the
    # early-boot aplay service needs no codec stack. Lives OUTSIDE the
    # theme dir so it stays in the system closure, not initrd.
    mkdir -p "$out/share/og-xbox"
    ffmpeg -v error -y -i "$srcVideo" -vn \
      -c:a pcm_s16le -ac 2 -ar 48000 \
      "$out/share/og-xbox/boot-audio.wav"

    # Theme descriptor with absolute store paths (same convention as
    # nixpkgs adi1090x-plymouth-themes).
    cat > "$themeDir/og-xbox.plymouth" <<EOF
    [Plymouth Theme]
    Name=OG Xbox
    Description=Original Xbox boot animation (local personal theme, 1080p60)
    ModuleName=script

    [script]
    ImageDir=$themeDir
    ScriptFile=$themeDir/og-xbox.script
    EOF

    # Playback script (see file header for logic notes). Stamp the real
    # frame count in so progress/refresh math can never overshoot.
    cp ${./og-xbox.script} "$themeDir/og-xbox.script"
    substituteInPlace "$themeDir/og-xbox.script" \
      --replace 'total_frames = 622;' "total_frames = $frameCount;"

    echo "theme size: $(du -sh "$themeDir" | cut -f1), audio: $(du -h "$out/share/og-xbox/boot-audio.wav" | cut -f1)"

    runHook postBuild
  '';

  dontInstall = true;

  meta = with lib; {
    description = "Plymouth theme playing the original Xbox boot animation (1080p60 frames)";
    license = licenses.unfree; # Microsoft Xbox assets, personal local use only
    platforms = platforms.linux;
  };
}
