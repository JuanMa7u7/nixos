{ pkgs, ... }:
{
  imports = [ ./openrgb.nix ./hyprland.nix ./fonts.nix ./upstream-compat.nix ./audio.nix ];

  # Prevent /boot from filling up again (see thinkpad-l15 2026-09-30: 511M
  # EFI partition hit 100% on stale systemd-boot kernels + 100+ loader
  # entries). Caps GRUB menu entries and garbage-collects weekly.
  boot.loader.grub.configurationLimit = 10;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Local time for both hosts (was defaulting to UTC).
  time.timeZone = "America/Mexico_City";
  programs.zsh.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 5900 5901 ];
  };

  boot.extraModprobeConfig = ''
    options bluetooth disable_ertm=Y
    options btusb enable_autosuspend=n
  '';

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
        JustWorksRepairing = "always";
      };
      Policy.AutoEnable = true;
    };
  };

  hardware.xpadneo.enable = true;
  services.blueman.enable = true;

  environment.sessionVariables = {
    PRISMA_FMT_BINARY = "${pkgs.prisma-engines_6}/bin/prisma-fmt";
    PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines_6}/bin/query-engine";
    PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines_6}/lib/libquery_engine.node";
    PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines_6}/bin/schema-engine";
  };

  users.users."juan_ma7u7" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "docker" "games" ];
    shell = pkgs.zsh;
  };

  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];

  boot.supportedFilesystems = [ "ntfs" "exfat" ];
  security.polkit.enable = true;

  services = {
    gvfs.enable = true;
    udisks2.enable = true;
    tailscale.enable = true;
    printing = {
      enable = true;
      drivers = with pkgs; [ gutenprint ];
    };
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    tailscale
    system-config-printer
    icu
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ icu ];

  openrgb.enable = true;
}
