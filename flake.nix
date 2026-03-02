{
  description = "JuanMa NixOS (Hydenix) multi-host";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hydenix = {
      url = "github:richen604/hydenix";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nixarr.url = "github:rasmus-kirk/nixarr";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs@{ self, ... }:
  let
    SYSTEM = "x86_64-linux";
    lib = inputs.hydenix.inputs.nixpkgs.lib;

    mkHost = hostName: extraModules:
      lib.nixosSystem {
        system = SYSTEM;
        specialArgs = { inherit inputs hostName; };

        modules =
          [
            ./modules/common.nix
            ./hosts/${hostName}/hardware-configuration.nix
            ./hosts/${hostName}/configuration.nix
          ]
          ++ extraModules;
      };
  in
  {
    nixosConfigurations = {
      thinkpad-l15 = mkHost "thinkpad-l15" [
        inputs.hydenix.inputs.nixos-hardware.nixosModules.lenovo-thinkpad-l15-amd
        inputs.hydenix.inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.hydenix.inputs.nixos-hardware.nixosModules.common-pc
        inputs.hydenix.inputs.nixos-hardware.nixosModules.common-pc-ssd
      ];

      mamalona = mkHost "mamalona" [
        inputs.hydenix.inputs.nixos-hardware.nixosModules.common-pc
        inputs.hydenix.inputs.nixos-hardware.nixosModules.common-pc-ssd
        inputs.hydenix.inputs.nixos-hardware.nixosModules.common-gpu-nvidia
      ];
    };
  };
}
