{ config, lib, pkgs, ... }:
{
  # imports = [ ./system.nix ];

  # ThinkPad L15 is NVMe-only (no /dev/sda) with a GPT + EFI system
  # partition, previously booted via systemd-boot. Install GRUB as the EFI
  # removable fallback: no NVRAM writes, no efibootmgr dependency, boots via
  # EFI/BOOT/BOOTX64.EFI regardless of stale firmware entries.
  boot.loader.grub = {
    enable = true;
    devices = [ "nodev" ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

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
