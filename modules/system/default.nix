{ ... }:

{
  imports = [
    # ./example.nix - add your modules here
  ];

  boot.supportedFilesystems = [ "ntfs" "exfat" ];

  security.polkit.enable = true;

  services = {
    gvfs.enable = true;
    udisks2.enable = true;
  };

  environment.systemPackages = [
    # pkgs.vscode - hydenix's vscode version
    # pkgs.userPkgs.vscode - your personal nixpkgs version
  ];
}
