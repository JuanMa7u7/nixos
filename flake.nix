{
  description = "JuanMa NixOS multi-host configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hydenix.url = "github:richen604/hydenix";

    caelestia-shell = {
      url = "github:Razkaroth/caelestia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nixarr.url = "github:rasmus-kirk/nixarr";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs:
    let
      system = "x86_64-linux";
      lib = inputs.nixpkgs.lib;

      mkHost =
        {
          hostName,
          hardwareModules ? [ ],
          extraModules ? [ ],
        }:
        lib.nixosSystem {
          inherit system;

          pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ inputs.hydenix.overlays.default ];
          };

          specialArgs = {
            inherit hostName inputs;
          };

          modules =
            [
              ./common/default.nix
              ./hosts/${hostName}/hardware-configuration.nix
              ./hosts/${hostName}/configuration.nix
            ]
            ++ hardwareModules
            ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        thinkpad-l15 = mkHost {
          hostName = "thinkpad-l15";
          hardwareModules = [
            inputs.hydenix.inputs.nixos-hardware.nixosModules.common-cpu-amd
            inputs.hydenix.inputs.nixos-hardware.nixosModules.common-pc
            inputs.hydenix.inputs.nixos-hardware.nixosModules.common-pc-ssd
          ];
        };

        mamalona = mkHost {
          hostName = "mamalona";
          hardwareModules = [
            inputs.hydenix.inputs.nixos-hardware.nixosModules.common-pc
            inputs.hydenix.inputs.nixos-hardware.nixosModules.common-pc-ssd
            inputs.hydenix.inputs.nixos-hardware.nixosModules.common-gpu-nvidia
          ];
        };
      };
    };
}
