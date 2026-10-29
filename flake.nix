{
  description = "JuanMa NixOS multi-host configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # AnyDesk 8.1.0 needs patchelf 0.15.2; newer patchelf breaks its ELF loader.
    nixpkgs-patchelf.url = "github:NixOS/nixpkgs/c59305bab2065cfecc4944690d9eedbb56f3a9fa";

    home-manager.url = "github:nix-community/home-manager";

    illogical-flake = {
      url = "github:soymou/illogical-flake?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Launcher for Minecraft Bedrock Edition (Codeberg)
    trinity-launcher.url = "git+https://codeberg.org/javiercplus/Trinity-Launcher-NIXOS";

    # Elgato 4K60 Pro capture card driver
    sc0710.url = "github:Nakildias/sc0710";

  };

  outputs = inputs:
    let
      system = "x86_64-linux";
      userName = "juan_ma7u7";
      lib = inputs.nixpkgs.lib;

      # mkHost is the single entry point for every host. withHomeManager
      # defaults to true so existing desktop hosts keep their user config;
      # the headless homelab host opts out entirely (no home-manager
      # evaluation, no hosts/<name>/home.nix + hm/ files required).
      mkHost =
        {
          hostName,
          hardwareModules ? [ ],
          extraModules ? [ ],
          withHomeManager ? true,
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
            inherit hostName inputs withHomeManager userName;
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
            srcVideo = ./assets/boot.webm;
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

        # Headless homelab server (HP Pavilion dm1 / AMD E-350, then a
        # ThinkCentre/EliteDesk mini PC). No desktop stack, no home-manager.
        # The whole server stack lives in common/server/ so desktop hosts
        # are completely unaffected.
        homelab = mkHost {
          hostName = "homelab";
          withHomeManager = false;
          extraModules = [ ./common/server ];
        };
      };
    };
}
