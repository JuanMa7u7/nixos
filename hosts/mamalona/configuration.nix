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

  boot.kernelModules = [ "v4l2loopback" ];

  # v4l2loopback configuration for BluCast virtual camera
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=10 card_label="BluCast Virtual Camera" exclusive_caps=1 max_buffers=2 max_openers=10
  '';

  services.udev.extraRules = ''
    SUBSYSTEM=="video4linux", ATTR{name}=="BluCast Virtual Camera", MODE="0666", TAG+="uaccess"
  '';

  virtualisation.docker = {
    enableNvidia = true;
  };
}
