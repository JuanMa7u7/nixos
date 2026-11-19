
{ inputs, ... }:

let
  system = "x86_64-linux";

  pkgsForPatch = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  illogicalPatched = pkgsForPatch.applyPatches {
    name = "illogical-flake-patched";
    src = inputs.illogical-flake.outPath;

    patches = [
      ../../patches/illogical-flake-fix.patch
    ];
  };

  illogicalInputs = {
    inherit (inputs) quickshell nur dotfiles;
  };

  illogicalModule =
    { config, lib, pkgs, ... }:
    (import "${illogicalPatched}/home-module.nix") {
      inherit config lib pkgs;
      inputs = illogicalInputs;
    };

in
{
  imports = [
    illogicalModule
    ./illogical.nix
    ./programs
    ./packages
    ./confs
    ./services
  ];

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
