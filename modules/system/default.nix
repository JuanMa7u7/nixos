{ pkgs, ... }:
{
  imports = [ ];

  boot.supportedFilesystems = [ "ntfs" "exfat" ];

  security.polkit.enable = true;

  services = {
    gvfs.enable = true;
    udisks2.enable = true;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  environment.systemPackages = with pkgs; [ docker-compose ];
}
