{ ... }:
{
  # ---------------------------------------------------------------------------
  # Vaultwarden — Bitwarden-compatible password manager (OCI container)
  # ---------------------------------------------------------------------------
  # Data lives on the host at /var/lib/homelab/services/vaultwarden so the
  # container can be recreated freely. Web UI is published on host port 8222
  # (NOT 80 — AdGuard owns that once its wizard completes).
  #
  # FIRST-RUN ORDER:
  #   1. Browse to http://<homelab-ip>:8222 and create your account.
  #   2. Set SIGNUPS_ALLOWED = "false" below and rebuild:
  #        sudo nixos-rebuild switch --flake .#homelab
  #
  # SECURITY: never expose 8222 to the internet directly. Reach it over the
  # tailnet (already trusted in networking.nix) or put it behind an HTTPS
  # reverse proxy and set DOMAIN accordingly.
  virtualisation.oci-containers.containers.vaultwarden = {
    image = "vaultwarden/server:latest";
    ports = [ "8222:80" ];
    volumes = [ "/var/lib/homelab/services/vaultwarden:/data" ];
    environment = {
      # Set this once served over HTTPS so generated URLs/redirects are correct.
      # DOMAIN = "https://vault.example.com";
      # Token that unlocks the /admin panel — set a long random value to enable.
      # ADMIN_TOKEN = "CHANGE_ME";
      SIGNUPS_ALLOWED = "true";
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/homelab/services/vaultwarden 0755 root root -"
  ];
}
