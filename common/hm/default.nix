{ inputs, ... }:
{
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
    ./programs
    ./packages
    ./confs
    ./caelestia.nix
    ./hydenix.nix
  ];
}
