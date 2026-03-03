{ pkgs, ... }:
{
  hydenix.hm.theme.active = "Scarlet Night";

  home.sessionVariables = {
    STEAMLIBRARY = "/mnt/juegos-ssd/SteamLibrary";
    STEAMLIBRARY_SSD = "/mnt/juegos-ssd/SteamLibrary";
    STEAMLIBRARY_HDD = "/mnt/juegos-hdd/SteamLibrary";
    PRESSURE_VESSEL_FILESYSTEMS_RW =
      "\${HOME}:/mnt/juegos-ssd:/mnt/juegos-hdd:/mnt/datos";
  };

  home.file = {
    ".config/hypr/monitors.conf" = pkgs.lib.mkForce {
      source = ../../modules/hm/confs/hosts/mamalona/monitors.conf;
      force = true;
      mutable = false;
    };
  };
}
