{ inputs, ... }:
{
  imports = [
    inputs.illogical-flake.homeManagerModules.default
    ./illogical.nix
    ./programs
    ./packages
    ./confs
    ./services
  ];

  # Generates ~/.config/user-dirs.dirs so `xdg-user-dir PICTURES` resolves to
  # ~/Pictures instead of $HOME (no user-dirs.dirs => fallback to $HOME).
  # end-4's CTRL+Print bind saves to $(xdg-user-dir PICTURES)/Screenshots.
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
