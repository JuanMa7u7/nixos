{ config, lib, pkgs, ... }:

let
  script = pkgs.writeShellScript "gnome-keyring-default-collection" ''
    export PATH="${lib.makeBinPath [
      pkgs.libsecret
      pkgs.systemd
      pkgs.coreutils
      pkgs.gnused
    ]}"

    # Do not let gnome-keyring pop up its "choose a password for the new
    # keyring" dialog: unattended, the prompt is dismissed and the wallet is
    # created without a password, which is what we want here (an unlocked,
    # passwordless wallet inside the user's own 0700 data dir).
    unset DISPLAY WAYLAND_DISPLAY

    keyrings="${config.xdg.dataHome}/keyrings"

    default_alias() {
      busctl --user --json=short call \
        org.freedesktop.secrets /org/freedesktop/secrets \
        org.freedesktop.Secret.Service ReadAlias s default 2>/dev/null \
        | tr -d '"' \
        | sed -n 's/.*data:\[\([^]]*\)\].*/\1/p'
    }

    # The session bus (and with it the Secret Service) may not be up yet this
    # early after login, so retry for a while before giving up.
    alias=""
    for _ in $(seq 1 20); do
      alias="$(default_alias)"
      [ -n "$alias" ] && break
      sleep 3
    done

    # A collection already exists (locked or not): leave it, and its
    # password, alone.
    if [ -n "$alias" ] && [ "$alias" != "/" ]; then
      echo "Default keyring collection present: $alias"
      exit 0
    fi

    # No collection at all: the Secret Service can only create one through a
    # prompt, and gnome-keyring dismisses that prompt when nobody answers
    # it, which yields an empty, unlocked wallet.
    echo "No default keyring collection found, creating an empty one."
    mkdir -p "$keyrings"
    printf 'bootstrap' | timeout 120 secret-tool store --label="keyring bootstrap" \
      service org.nixos.keyring-bootstrap >/dev/null 2>&1 || true
    timeout 30 secret-tool clear service org.nixos.keyring-bootstrap \
      >/dev/null 2>&1 || true

    alias="$(default_alias)"
    if [ -n "$alias" ] && [ "$alias" != "/" ]; then
      echo "Default keyring collection created: $alias"
    else
      echo "Could not create a default keyring collection." >&2
      exit 1
    fi
  '';
in
{
  # Ensures the user session always has an *unlocked default collection* in
  # the Secret Service, not just a running gnome-keyring daemon.
  #
  # Why this is needed (verified on mamalona, 2026-10-21):
  #   `services.gnome.gnome-keyring.enable` (common/system/keyring.nix) starts
  #   the daemon and wires pam_gnome_keyring.so into /etc/pam.d/login, but
  #   greetd's PAM stack only ever passes `auto_start` to the session stack
  #   and never hands the login password to it. The daemon therefore starts
  #   *without* a password, so no keyring is ever created: ~/.local/share/
  #   keyrings stayed empty and `org.freedesktop.secrets` answered with no
  #   collection at all. Credential stores (the Xodus Nexus Rust backend uses
  #   dbus-secret-service-keyring-store) then failed every read/write with
  #   "The system keyring could not be accessed. Check that it is running and
  #   unlocked." even though the daemon was running and owned the bus name.
  #
  # What this does:
  #   At session start, check the Secret Service alias "default". If a
  #   collection already exists (locked or not) this is a no-op, so a
  #   user-set keyring password is never touched and never re-prompted. If
  #   there is no collection, create one empty and passwordless (file mode
  #   0600 inside the user's own data dir) and drop the bootstrap secret
  #   again. The file persists, so this only ever runs once per keyring
  #   directory, and gnome-keyring unlocks a passwordless wallet by itself on
  #   every later login.
  #
  # Notes:
  #   * `default.target` is used on purpose: `graphical-session-pre.target` is
  #     inactive in a greetd/Hyprland session, so a unit bound to it would
  #     never run.
  #   * The creation step is wrapped in `timeout` so a stuck prompt can never
  #     hang the unit forever.
  systemd.user.services.gnome-keyring-default-collection = {
    Unit = {
      Description = "Ensure an unlocked default keyring collection exists";
      Documentation = [ "man:secret-tool(1)" "man:busctl(1)" ];
      After = [ "dbus-broker.service" ];
      Wants = [ "dbus-broker.service" ];
    };

    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${script}";
      TimeoutStartSec = 180;
    };

    Install.WantedBy = [ "default.target" ];
  };

  # Start it right away when the config is applied, so the collection exists
  # without waiting for the next login. It runs after "linkGeneration" so the
  # unit file is in place already. `systemctl --user` needs a running user
  # manager, which is not guaranteed (e.g. `home-manager switch` over SSH),
  # hence the `|| true`.
  home.activation.gnomeKeyringDefaultCollection = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    systemctl --user start gnome-keyring-default-collection.service \
      >/dev/null 2>&1 || true
  '';
}
