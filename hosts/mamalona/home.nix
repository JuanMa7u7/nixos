{ ... }:
{
  imports = [
    ./hm
  ];

  services.blucast.enable = true;

  home.sessionVariables = {
    STEAMLIBRARY = "/mnt/juegos-ssd/SteamLibrary";
    STEAMLIBRARY_SSD = "/mnt/juegos-ssd/SteamLibrary";
    STEAMLIBRARY_HDD = "/mnt/juegos-hdd/SteamLibrary";
    PRESSURE_VESSEL_FILESYSTEMS_RW =
      "\${HOME}:/mnt/juegos-ssd:/mnt/juegos-hdd:/mnt/datos";
  };
}
