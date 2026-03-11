{ inputs, ... }:
{
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
    ./programs
    ./packages
    ./confs
    ./services
    ./caelestia.nix
    ./hydenix.nix
  ];
}
