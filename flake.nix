{
  description = "JuanMa NixOS multi-host configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";

    illogical-flake = {
      url = "github:soymou/illogical-flake?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nixarr.url = "github:rasmus-kirk/nixarr";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Launcher for Minecraft Bedrock Edition (Codeberg)
    trinity-launcher.url = "git+https://codeberg.org/javiercplus/Trinity-Launcher-NIXOS";

    # Elgato 4K60 Pro capture card driver
    sc0710.url = "github:Nakildias/sc0710";

    # Xodus Gaming — Xbox PC game migration to Linux
    xodus = {
      url = "github:xodus-gaming/xodus";
      flake = false;
    };
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
             config = {
               allowUnfree = true;
                permittedInsecurePackages = [ "nodejs-22.12.0" "nodejs-slim-22.12.0" ];
             };
              overlays = [ ];
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
      packages.${system} = {
        # Standalone build for measuring the theme without a full rebuild:
        # nix build .#og-xbox-plymouth
        og-xbox-plymouth =
          (import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
          }).callPackage ./packages/og-xbox-plymouth {
            srcVideo = /home/juan_ma7u7/nixos/assets/boot.webm;
          };
      };

      nixosConfigurations = {        thinkpad-l15 = mkHost {
          hostName = "thinkpad-l15";
          hardwareModules = [
            inputs.nixos-hardware.nixosModules.common-cpu-amd
            inputs.nixos-hardware.nixosModules.common-pc
            inputs.nixos-hardware.nixosModules.common-pc-ssd
          ];
        };

        mamalona = mkHost {
          hostName = "mamalona";
          hardwareModules = [
            inputs.nixos-hardware.nixosModules.common-pc
            inputs.nixos-hardware.nixosModules.common-pc-ssd
            inputs.nixos-hardware.nixosModules.common-gpu-nvidia
            inputs.sc0710.nixosModules.default
          ];
        };
      };
    };
}
