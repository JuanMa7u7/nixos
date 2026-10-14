{ lib, ... }:
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/chrome" = "zen-beta.desktop";
      "text/html" = "zen-beta.desktop";
      "application/x-extension-htm" = "zen-beta.desktop";
      "application/x-extension-html" = "zen-beta.desktop";
      "application/x-extension-shtml" = "zen-beta.desktop";
      "application/xhtml+xml" = "zen-beta.desktop";
      "application/x-extension-xhtml" = "zen-beta.desktop";
      "application/x-extension-xht" = "zen-beta.desktop";

      "image/jpeg" = [ "org.gnome.gThumb.desktop" ];
      "image/jpg" = [ "org.gnome.gThumb.desktop" ];
      "image/png" = [ "org.gnome.gThumb.desktop" ];
      "image/gif" = [ "org.gnome.gThumb.desktop" ];
      "image/bmp" = [ "org.gnome.gThumb.desktop" ];
      "image/tiff" = [ "org.gnome.gThumb.desktop" ];
      "image/x-bmp" = [ "org.gnome.gThumb.desktop" ];
      "image/x-ico" = [ "org.gnome.gThumb.desktop" ];
      "image/x-png" = [ "org.gnome.gThumb.desktop" ];
      "image/x-tga" = [ "org.gnome.gThumb.desktop" ];
      "image/x-tiff" = [ "org.gnome.gThumb.desktop" ];
      "image/x-webp" = [ "org.gnome.gThumb.desktop" ];
      "image/webp" = [ "org.gnome.gThumb.desktop" ];
      "image/svg+xml" = [ "org.gnome.gThumb.desktop" ];
      
      "application/javascript" = "code.desktop";
      "application/json" = "code.desktop";
      "application/x-shellscript" = "code.desktop";
      "application/xml" = "code.desktop";
      "inode/directory" = "org.kde.dolphin.desktop";
      "text/css" = "code.desktop";
      "text/markdown" = "code.desktop";
      "text/plain" = "code.desktop";
      "text/x-c++src" = "code.desktop";
      "text/x-csrc" = "code.desktop";
      "text/x-go" = "code.desktop";
      "text/x-java-source" = "code.desktop";
      "text/x-python" = "code.desktop";
      "text/x-typescript" = "code.desktop";
      "x-scheme-handler/about" = "org.kde.dolphin.desktop";
      "x-scheme-handler/file" = "org.kde.dolphin.desktop";

      "video/mp4" = "io.github.mpc_qt.mpc-qt.desktop";
      "video/x-matroska" = "io.github.mpc_qt.mpc-qt.desktop";
      "video/webm" = "io.github.mpc_qt.mpc-qt.desktop";
      "video/avi" = "io.github.mpc_qt.mpc-qt.desktop";
      "video/x-msvideo" = "io.github.mpc_qt.mpc-qt.desktop";
      "video/quicktime" = "io.github.mpc_qt.mpc-qt.desktop";
      "video/mpeg" = "io.github.mpc_qt.mpc-qt.desktop";
      "video/x-mpeg" = "io.github.mpc_qt.mpc-qt.desktop";
      "video/mp2t" = "io.github.mpc_qt.mpc-qt.desktop";
      "video/3gpp" = "io.github.mpc_qt.mpc-qt.desktop";
      "video/3gpp2" = "io.github.mpc_qt.mpc-qt.desktop";
      "video/x-flv" = "io.github.mpc_qt.mpc-qt.desktop";
      "video/x-fli" = "io.github.mpc_qt.mpc-qt.desktop";
      "video/x-m4v" = "io.github.mpc_qt.mpc-qt.desktop";
      "video/x-ms-wmv" = "io.github.mpc_qt.mpc-qt.desktop";
      "video/x-ms-asf" = "io.github.mpc_qt.mpc-qt.desktop";
      "video/x-ogm" = "io.github.mpc_qt.mpc-qt.desktop";

      "audio/mpeg" = "io.github.mpc_qt.mpc-qt.desktop";
      "audio/mp3" = "io.github.mpc_qt.mpc-qt.desktop";
      "audio/ogg" = "io.github.mpc_qt.mpc-qt.desktop";
      "audio/flac" = "io.github.mpc_qt.mpc-qt.desktop";
      "audio/wav" = "io.github.mpc_qt.mpc-qt.desktop";
      "audio/x-wav" = "io.github.mpc_qt.mpc-qt.desktop";
      "audio/aac" = "io.github.mpc_qt.mpc-qt.desktop";
      "audio/x-m4a" = "io.github.mpc_qt.mpc-qt.desktop";
      "audio/x-aac" = "io.github.mpc_qt.mpc-qt.desktop";
      "audio/x-flac" = "io.github.mpc_qt.mpc-qt.desktop";
      "audio/x-ogg" = "io.github.mpc_qt.mpc-qt.desktop";
      "audio/webm" = "io.github.mpc_qt.mpc-qt.desktop";
      "audio/x-ms-wma" = "io.github.mpc_qt.mpc-qt.desktop";
      "audio/midi" = "io.github.mpc_qt.mpc-qt.desktop";
      "audio/x-midi" = "io.github.mpc_qt.mpc-qt.desktop";
      "audio/x-musepack" = "io.github.mpc_qt.mpc-qt.desktop";

      "application/pdf" = "onlyoffice-desktopeditors.desktop";
      "application/msword" = "onlyoffice-desktopeditors.desktop";
      "application/vnd.ms-word" = "onlyoffice-desktopeditors.desktop";
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "onlyoffice-desktopeditors.desktop";
      "application/vnd.ms-excel" = "onlyoffice-desktopeditors.desktop";
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "onlyoffice-desktopeditors.desktop";
      "application/vnd.ms-powerpoint" = "onlyoffice-desktopeditors.desktop";
      "application/vnd.openxmlformats-officedocument.presentationml.presentation" = "onlyoffice-desktopeditors.desktop";
      "text/csv" = "onlyoffice-desktopeditors.desktop";
      "application/vnd.oasis.opendocument.text" = "onlyoffice-desktopeditors.desktop";
      "application/vnd.oasis.opendocument.spreadsheet" = "onlyoffice-desktopeditors.desktop";
      "application/vnd.oasis.opendocument.presentation" = "onlyoffice-desktopeditors.desktop";
      "application/rtf" = "onlyoffice-desktopeditors.desktop";
      "text/rtf" = "onlyoffice-desktopeditors.desktop";

      "application/zip" = "ark.desktop";
      "application/x-zip-compressed" = "ark.desktop";
      "application/x-tar" = "ark.desktop";
      "application/x-gzip" = "ark.desktop";
      "application/x-bzip2" = "ark.desktop";
      "application/x-xz" = "ark.desktop";
      "application/x-7z-compressed" = "ark.desktop";
      "application/x-rar" = "ark.desktop";
      "application/x-rar-compressed" = "ark.desktop";
      "application/x-compress" = "ark.desktop";
      "application/x-xz-compressed" = "ark.desktop";
      "application/java-archive" = "ark.desktop";
      "application/x-archive" = "ark.desktop";
      "application/x-cd-image" = "ark.desktop";
      "application/x-iso9660-image" = "ark.desktop";

      "model/gltf-binary" = "blender.desktop";
      "model/gltf+json" = "blender.desktop";
      "model/obj" = "blender.desktop";
      "application/x-blender" = "blender.desktop";
      "application/x-obj" = "blender.desktop";
      "application/vnd.blender" = "blender.desktop";
      "application/x-3ds" = "blender.desktop";
      "image/x-3ds" = "blender.desktop";
      "application/fbx" = "blender.desktop";
      "model/fbx" = "blender.desktop";
      "application/x-fbx" = "blender.desktop";

      "application/gcode" = "com.orcaslicer.OrcaSlicer.desktop";
      "application/x-gcode" = "com.orcaslicer.OrcaSlicer.desktop";
      "model/stl" = "com.orcaslicer.OrcaSlicer.desktop";
      "application/sla" = "com.orcaslicer.OrcaSlicer.desktop";
      "application/vnd.ms-3mfdocument" = "com.orcaslicer.OrcaSlicer.desktop";
      "application/3mf" = "com.orcaslicer.OrcaSlicer.desktop";
      "application/x-3mf" = "com.orcaslicer.OrcaSlicer.desktop";
    };
  };
}
