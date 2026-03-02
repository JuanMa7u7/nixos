{ config, pkgs, lib, ... }:

{
  programs.steam.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;

    # REQUIRED en drivers >= 560
    open = true;

    nvidiaSettings = true;
  };

  # Evita el assert de PRIME: en desktop no lo uses
  hardware.nvidia.prime = {
    offload.enable = lib.mkForce false;
    sync.enable = lib.mkForce false;
  };

  # Steam/Proton 32-bit
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
