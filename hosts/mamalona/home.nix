{ pkgs, ... }:
{
  imports = [];

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
  ];

  services.blucast.enable = true;
  services.sc0710-audio.enable = true;

  home.sessionVariables = {
    STEAMLIBRARY = "/mnt/juegos-ssd/SteamLibrary";
    STEAMLIBRARY_SSD = "/mnt/juegos-ssd/SteamLibrary";
    STEAMLIBRARY_HDD = "/mnt/juegos-hdd/SteamLibrary";
    PRESSURE_VESSEL_FILESYSTEMS_RW =
      "\${HOME}:/mnt/juegos-ssd:/mnt/juegos-hdd:/mnt/datos";
    # NVIDIA Wayland (mamalona-only: RTX 4080 Super). Confined here so the
    # AMD-based thinkpad-l15 never evaluates these.
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };
}
