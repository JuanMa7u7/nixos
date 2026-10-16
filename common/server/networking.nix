{ lib, ... }:
{
  # Hostname is set centrally in common/default.nix from mkHost's specialArgs
  # (networking.hostName = hostName), so it is intentionally not duplicated.

  # ---------------------------------------------------------------------------
  # VPN
  # ---------------------------------------------------------------------------
  # Tailscale is already enabled globally (common/system/default.nix); kept
  # explicit here because the tailnet is the primary way to reach the web
  # admin panels from outside the LAN.
  services.tailscale.enable = true;

  # Kernel IP forwarding so the box can later act as a Tailscale subnet router
  # (advertise the LAN) or forward traffic between interfaces.
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # ---------------------------------------------------------------------------
  # Firewall
  # ---------------------------------------------------------------------------
  networking.firewall = {
    enable = true;

    # Everything arriving over the tailnet can reach the admin UIs without
    # opening each port twice.
    trustedInterfaces = [ "tailscale0" ];

    # Reverse-path check must be loose for Tailscale subnet routing to work.
    checkReversePath = "loose";

    # Authoritative list for this host. mkForce drops the VNC ports (5900/5901)
    # that common/system/default.nix opens for the desktop hosts. IMPORTANT:
    # 22 must stay in this list — mkForce overrides the openssh module's own
    # firewall contribution too, so omitting it would lock you out of SSH.
    allowedTCPPorts = lib.mkForce [
      22    # SSH
      53    # AdGuard DNS (TCP)
      80    # AdGuard web UI (after the first-run wizard)
      3000  # AdGuard first-run setup wizard
      8222  # Vaultwarden web vault
    ];
    allowedUDPPorts = lib.mkForce [
      53    # AdGuard DNS (UDP)
      # 67  # uncomment when AdGuard runs as the LAN DHCP server (see adguard.nix)
    ];
  };

  # ---------------------------------------------------------------------------
  # Networking backend
  # ---------------------------------------------------------------------------
  # NetworkManager is force-disabled in server-base.nix; use systemd-networkd
  # with DHCP on the wired interface. A wildcard match keeps this working both
  # on the dm1 (`eth0`) and on a future mini PC (`enp*`/`eno*`).
  networking.useNetworkd = true;
  systemd.network = {
    enable = true;
    networks."40-wired" = {
      matchConfig.Name = [ "en*" "eth*" ];
      networkConfig = {
        DHCP = "yes";
        IPv6AcceptRA = true;
      };
    };
  };
}
