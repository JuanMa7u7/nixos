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
    enable32Bit = true; # Steam/Proton 32-bit titles
    extraPackages = with pkgs; [
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  # Light gaming: Steam + compat tooling (heavier stack — gamescope session,
  # firewall openings — stays mamalona-only). Library defaults to
  # ~/.steam/steam via common/hm/confs (STEAMLIBRARY).
  programs.steam = {
    enable = true;
    protontricks.enable = true;
    extest.enable = true; # virtual controller for Steam Input (xpadneo is system-wide)
  };

  programs.gamemode.enable = true;

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
