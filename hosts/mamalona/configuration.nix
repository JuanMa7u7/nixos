{ lib, ... }:
{
  imports = [ ./system.nix ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    protontricks.enable = true;
    extest.enable = true;
    gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.displayManager.sddm.wayland.enable = lib.mkForce false;

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
