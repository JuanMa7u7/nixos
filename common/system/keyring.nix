{ ... }:
{
  # Unlocks the default (login) keyring during login. greetd's PAM stack
  # substacks /etc/pam.d/login, so tuigreet logins inherit this too.
  # Without it the Secret Service stays locked and apps that store
  # credentials (Xodus Nexus sign-in) fail with "system keyring could
  # not be accessed".
  services.gnome.gnome-keyring.enable = true;
}
