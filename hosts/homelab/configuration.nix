{ config, lib, pkgs, ... }:
{
  # HP Pavilion dm1 (AMD E-350) boots via legacy BIOS -> GRUB on /dev/sda.
  # The whole headless server stack (server-base, networking, containers)
  # comes from common/server, imported via mkHost in flake.nix.
  #
  # MIGRATION: if this firmware turns out to be UEFI, or once you move to a
  # ThinkCentre/EliteDesk mini PC, replace this block with the removable-EFI
  # recipe used by thinkpad-l15:
  #   boot.loader.grub = {
  #     enable = true;
  #     devices = [ "nodev" ];
  #     efiSupport = true;
  #     efiInstallAsRemovable = true;
  #   };
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  # 6GB RAM on very slow Bobcat cores: compress half of RAM and kill memory
  # hogs early (same pattern as hosts/thinkpad-l15/configuration.nix).
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  services.earlyoom = {
    enable = true;
    enableNotifications = true;
    extraArgs = [
      "-m 10"
      "-s 30"
    ];
  };
}
