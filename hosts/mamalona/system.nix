{ userName, ... }:
{
  fileSystems."/mnt/datos" = {
    device = "/dev/disk/by-uuid/968E1A158E19EE8D";
    fsType = "ntfs-3g";
    options = [ "nofail" "rw" "uid=1000" "gid=100" "umask=022" "windows_names" ];
  };

  fileSystems."/mnt/juegos-hdd" = {
    device = "/dev/disk/by-uuid/DE4AD9B24AD987A3";
    fsType = "ntfs-3g";
    options = [ "nofail" "rw" "uid=1000" "gid=100" "umask=022" "windows_names" ];
  };

  systemd.tmpfiles.rules = [
    "z /mnt/juegos-ssd 0755 ${userName} users - -"
    "z /mnt/juegos-hdd 0755 ${userName} users - -"
    "Z /mnt/juegos-hdd/SteamLibrary 0755 ${userName} users - -"
    "Z /mnt/juegos-ssd/SteamLibrary 0755 ${userName} users - -"
  ];
}
