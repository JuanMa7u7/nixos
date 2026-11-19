{ lib, pkgs, inputs, ... }:

let
  pname = "anydesk";
  version = "8.1.0";

  src = pkgs.fetchurl {
    url = "https://download.anydesk.com/linux/anydesk-${version}-amd64.tar.gz";
    hash = "sha256-zS5P2eyTHZY7cBW8mQ2Q6M0lXcx9VZZTtpG3Bb6u7IQ=";
  };

  pkgsPatchelf = import inputs.nixpkgs-patchelf {
    system = pkgs.stdenv.hostPlatform.system;
  };

  anydesk = pkgs.anydesk.overrideAttrs (oldAttrs: {
    inherit pname version src;
    postFixup = lib.replaceStrings
      [ "patchelf" ]
      [ "${pkgsPatchelf.patchelf}/bin/patchelf" ]
      oldAttrs.postFixup;
  });
in
{
  home.packages = [ anydesk ];
}
