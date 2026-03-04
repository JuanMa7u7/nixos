{ ... }:
{
  fileSystems."/mnt/datos" = {
    device = "/dev/disk/by-uuid/968E1A158E19EE8D";
    fsType = "ntfs3";
    options = [ "rw" "uid=1000" "gid=100" "umask=022" "windows_names" ];
  };

  fileSystems."/mnt/juegos-hdd" = {
    device = "/dev/disk/by-uuid/DE4AD9B24AD987A3";
    fsType = "ntfs3";
    options = [ "rw" "uid=1000" "gid=100" "umask=022" "windows_names" ];
  };

  fileSystems."/mnt/juegos-ssd" = {
    device = "/dev/disk/by-uuid/FC8C3E5E8C3E141C";
    fsType = "ntfs3";
    options = [ "rw" "uid=1000" "gid=100" "umask=022" "windows_names" ];
  };

  systemd.tmpfiles.rules = [
    "d /mnt/juegos-hdd/SteamLibrary 0755 juan_ma7u7 users - -"
    "d /mnt/juegos-ssd/SteamLibrary 0755 juan_ma7u7 users - -"
  ];
}
