{ config, lib, pkgs, ... }:
{
  # Paused, i need to buy the hardware first, and then i will continue with the configuration
  # The hardware would be an Lenovo ThinkCentre M920q Tiny Desktop or similar, which is a small form factor PC that can be used as a home server.

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
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
