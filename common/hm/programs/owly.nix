{ pkgs, ... }:

let
  owly = pkgs.callPackage ../../../packages/owly { };
in
{
  home.packages = [ owly ];
}
