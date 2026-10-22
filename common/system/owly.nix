{ config, lib, pkgs, ... }:

let
  cfg = config.services.owly;
  package = pkgs.callPackage ../../packages/owly { };
  ifaces = [
    "awdl0"
    "owlymon0"
    "owlyibss0"
    "owlyap0"
  ];
  toml = pkgs.formats.toml { };

  # The release binary defaults to /usr/sbin/hostapd, which is not a NixOS
  # path. Keep user settings authoritative while providing the packaged tool.
  radioSettings = {
    hostapd = "${pkgs.hostapd}/bin/hostapd";
  } // cfg.settings;
in
{
  options.services.owly = {
    enable = lib.mkEnableOption "Owly, AirDrop's Wi-Fi radio and CLI";

    package = lib.mkOption {
      type = lib.types.package;
      default = package;
      defaultText = lib.literalExpression "pkgs.callPackage ../../packages/owly { }";
      description = "The Owly package to use.";
    };

    settings = lib.mkOption {
      inherit (toml) type;
      default = { };
      example = {
        station = "wlp1s0";
        allow_untested = true;
        channels = [ 149 ];
      };
      description = "Owly radio settings written to /etc/owly/radio.toml.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open TCP port 8771 on awdl0 for receiving files.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.packages = [ cfg.package ];
    services.dbus.packages = [ cfg.package ];
    security.polkit.enable = true;

    hardware.bluetooth.enable = lib.mkDefault true;

    systemd.services.owlyd.path = [
      config.networking.networkmanager.package
      pkgs.hostapd
      pkgs.iproute2
      pkgs.iputils
      pkgs.util-linux
    ];

    environment.etc."owly/radio.toml".source = toml.generate "owly-radio.toml" radioSettings;

    networking.networkmanager.unmanaged = map (iface: "interface-name:${iface}") ifaces;
    networking.firewall.interfaces.awdl0.allowedTCPPorts = lib.mkIf cfg.openFirewall [ 8771 ];

    systemd.network.links."10-owly-awdl0" = {
      matchConfig.OriginalName = "awdl0";
      linkConfig.MACAddressPolicy = "none";
    };

    services.udev.packages = [
      (pkgs.writeTextDir "lib/udev/rules.d/00-owly.rules" ''
        SUBSYSTEM=="net", KERNEL=="${lib.concatStringsSep "|" ifaces}", RUN:="${pkgs.coreutils}/bin/true"
      '')
    ];
  };
}
