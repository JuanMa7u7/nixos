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
}
