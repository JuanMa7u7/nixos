{ ... }:
{
  # Runs the gnome-keyring daemon (Secret Service provider) and wires
  # pam_gnome_keyring.so into /etc/pam.d/login, which greetd's PAM stack
  # includes, so tuigreet logins inherit it too.
  #
  # This is only half of the story: the daemon alone is not enough. greetd
  # never hands the login password to the session stack, so no keyring
  # collection is ever created and the Secret Service answers with an empty
  # wallet. Apps that persist credentials (Xodus Nexus MS sign-in) then fail
  # with "The system keyring could not be accessed. Check that it is running
  # and unlocked." even though the daemon is up and owns
  # org.freedesktop.secrets. The missing piece is an unlocked default
  # collection, which common/hm/services/keyring.nix creates per user.
  services.gnome.gnome-keyring.enable = true;
}
