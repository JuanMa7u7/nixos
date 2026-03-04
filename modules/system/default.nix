{ ... }:
{
  imports = [ ];

  boot.supportedFilesystems = [ "ntfs" "exfat" ];

  security.polkit.enable = true;

  services = {
    gvfs.enable = true;
    udisks2.enable = true;
  };

  environment.systemPackages = [ ];
}
