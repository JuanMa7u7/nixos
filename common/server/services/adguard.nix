{ ... }:
{
  # ---------------------------------------------------------------------------
  # AdGuard Home — network-wide DNS sinkhole + web admin panel
  # ---------------------------------------------------------------------------
  # Run as an OCI container (Docker backend set in server-base.nix). All
  # stateful data is bind-mounted onto the host under
  # /var/lib/homelab/services/adguard/, so the container itself is disposable
  # and upgrades/rebuilds never touch user data.
  #
  # Ports:
  #   53   DNS (tcp+udp)         <- LAN clients point their resolver here
  #   3000 first-run setup wizard
  #   80   web admin panel (after the wizard completes)
  virtualisation.oci-containers.containers.adguard = {
    image = "adguard/adguardhome:latest";
    ports = [
      "53:53/tcp"
      "53:53/udp"
      "3000:3000/tcp"
      "80:80/tcp"
    ];
    volumes = [
      "/var/lib/homelab/services/adguard/work:/opt/adguardhome/work"
      "/var/lib/homelab/services/adguard/conf:/opt/adguardhome/conf"
    ];
    # NET_ADMIN is needed for DHCP/ARP features (pre-staged for the guide below).
    capabilities = { NET_ADMIN = true; };
  };

  # Create the persistence tree declaratively (root-owned; the official image
  # runs as root by default, so it can write into these directories).
  systemd.tmpfiles.rules = [
    "d /var/lib/homelab/services 0755 root root -"
    "d /var/lib/homelab/services/adguard 0755 root root -"
    "d /var/lib/homelab/services/adguard/work 0755 root root -"
    "d /var/lib/homelab/services/adguard/conf 0755 root root -"
  ];

  # ===========================================================================
  # OPTIONAL GUIDE: run AdGuard Home as the LAN DHCP server
  # ===========================================================================
  # The config above uses Docker's default bridge network, which NATs traffic.
  # DHCP is broadcast-based (UDP 67/68) and does NOT traverse the Docker
  # bridge, so AdGuard's DHCP feature only works with HOST networking.
  #
  # To enable it, in order:
  #
  #  1) This file — switch the container to host networking and remove the
  #     "ports" list (host-mode containers bind host ports directly; Docker
  #     refuses to publish ports together with network_mode: host):
  #
  #        network = "host";
  #        # ports = [ ... ];   <-- delete or comment out
  #
  #     (the NET_ADMIN capability is already granted above, as DHCP requires.)
  #
  #  2) networking.nix — add 67 to the forced UDP list:
  #        allowedUDPPorts = lib.mkForce [ 53 67 ];
  #
  #  3) ROUTER — disable its built-in DHCP server FIRST (never run two DHCP
  #     servers on one LAN). Also create a static/reserved lease for the
  #     homelab's MAC address so its own IP stays stable across reboots.
  #
  #  4) AdGuard web UI (http://<homelab-ip>) -> DHCP settings:
  #       - DHCP server : enabled
  #       - Interface   : the wired LAN interface, e.g. enp2s0
  #                       (find it with `ip -br link`)
  #       - Gateway IP  : your ROUTER's IP (unless you route via the homelab)
  #       - Range/mask  : a pool that EXCLUDES the homelab's reserved IP and
  #                       any statically addressed devices
  #       - DNS servers : the homelab IP itself (so clients get ad-blocking)
  #
  #  5) Verify — from another machine run `sudo dhclient -v <iface>` (Linux)
  #     or inspect the client's lease; confirm leases appear under AdGuard's
  #     "DHCP leases" tab and queries in the "Query log".
  # ===========================================================================
}
