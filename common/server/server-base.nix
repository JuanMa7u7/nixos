{ lib, ... }:
{
  # ---------------------------------------------------------------------------
  # Headless base
  # ---------------------------------------------------------------------------
  # The OS itself must stay strictly headless: no X11/Wayland, no display
  # manager, no desktop session. The shared common/system modules enable a
  # full desktop stack (Hyprland, greetd, Bluetooth, printing, PipeWire, ...),
  # so we force them back off here. mkForce is required because the shared
  # modules set them to true at the normal priority. Desktop hosts are not
  # affected — they don't import this file.
  services.xserver.enable = lib.mkForce false;
  programs.hyprland.enable = lib.mkForce false;
  services.greetd.enable = lib.mkForce false;
  services.geoclue2.enable = lib.mkForce false;
  xdg.portal.enable = lib.mkForce false;

  # Networking is owned by systemd-networkd (see networking.nix) on a server.
  networking.networkmanager.enable = lib.mkForce false;

  # Desktop peripherals / services that make no sense on a headless box.
  hardware.bluetooth.enable = lib.mkForce false;
  services.blueman.enable = lib.mkForce false;
  hardware.xpadneo.enable = lib.mkForce false;
  services.printing.enable = lib.mkForce false;
  services.flatpak.enable = lib.mkForce false;
  services.gvfs.enable = lib.mkForce false;
  services.udisks2.enable = lib.mkForce false;
  services.pipewire.enable = lib.mkForce false;

  # The Plymouth splash pulls a ~100MB video theme into initrd — pure waste on
  # 6GB legacy hardware with no screen. (kernelParams quiet/splash harmless.)
  boot.plymouth.enable = lib.mkForce false;

  # OpenRGB is a desktop RGB-daemon; the shared module enables it by default.
  openrgb.enable = lib.mkForce false;

  # ---------------------------------------------------------------------------
  # SSH — public-key only
  # ---------------------------------------------------------------------------
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  users.users.juan_ma7u7.openssh.authorizedKeys.keys = [
    # >>> TODO(USER): REPLACE with your real public key BEFORE first deploy. <<<
    # Generate one with:  ssh-keygen -t ed25519 -C "juanma@homelab"
    # then paste the single line from ~/.ssh/id_ed25519.pub here. Until you do,
    # key auth will fail and you can only reach the box from its local console.
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI_PLACEHOLDER_REPLACE_ME_WITH_YOUR_REAL_PUBLIC_KEY juanma@homelab"
  ];

  # ---------------------------------------------------------------------------
  # Containers + storage hygiene
  # ---------------------------------------------------------------------------
  # Docker itself is enabled globally in common/system/default.nix; pin the
  # OCI-container backend to Docker so `virtualisation.oci-containers` matches
  # the running daemon (nixpkgs' default backend may be podman).
  virtualisation.oci-containers.backend = "docker";

  # Target disk is a Kingston SA400 SATA SSD — weekly discard keeps write
  # performance from degrading.
  services.fstrim.enable = true;

  # NOTE: automatic Nix garbage collection is already enabled for every host
  # in common/system/default.nix (weekly, --delete-older-than 14d), so it is
  # intentionally not duplicated here.
}
