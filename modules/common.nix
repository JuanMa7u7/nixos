{ config, pkgs, inputs, hostName, ... }:

let
  system = "x86_64-linux";

  # Igual que tu patrón actual con Hydenix overlay
  hydePkgs = import inputs.hydenix.inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [ inputs.hydenix.overlays.default ];

    # userPkgs como ya lo traías (para que no cambie tu lógica)
    userPkgs = inputs.nixpkgs {
      config.allowUnfree = true;
    };
  };
in
{
  nixpkgs.pkgs = hydePkgs;
  nixpkgs.config.allowUnfree = true;

  networking.hostName = hostName;

  imports = [
    inputs.hydenix.inputs.home-manager.nixosModules.home-manager
    inputs.hydenix.nixosModules.default
    ./system
  ];

  # Usuario (NO metas passwords en el repo)
  users.users."juan_ma7u7" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "docker" ];
    shell = hydePkgs.zsh;
  };

  # Home Manager (tu estructura ya vive en ./modules/hm)
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "nixbak";
    extraSpecialArgs = { inherit inputs; };

    users."juan_ma7u7" = {
      imports = [
        inputs.hydenix.homeModules.default
        ./hm
      ];
    };
  };

  # Hydenix base común
  hydenix = {
    enable = true;

    hostname = hostName;
    timezone = "America/Mexico_City";
    locale = "en_US.UTF-8";

    boot = {
      enable = true;
      useSystemdBoot = true;

      # Hydenix espera STRING aquí:
      grubTheme = "Retroboot";  # o "Pochita"
      grubExtraConfig = "";

      kernelPackages = hydePkgs.linuxPackages_zen;
    };

    gaming.enable = true;
    hardware.enable = true;
    network.enable = true;
    nix.enable = true;

    # En Hydenix es así (no hydenix.sddm.theme)
    sddm.enable = true;

    system.enable = true;
  };

  # Tu bloque de Prisma (si lo quieres común)
  environment.sessionVariables = with hydePkgs; {
    PRISMA_FMT_BINARY = "${prisma-engines}/bin/prisma-fmt";
    PRISMA_QUERY_ENGINE_BINARY = "${prisma-engines}/bin/query-engine";
    PRISMA_QUERY_ENGINE_LIBRARY = "${prisma-engines}/lib/libquery_engine.node";
    PRISMA_SCHEMA_ENGINE_BINARY = "${prisma-engines}/bin/schema-engine";
    PRISMA_INTROSPECTION_ENGINE_BINARY = "${prisma-engines}/bin/introspection-engine";
  };

  system.stateVersion = "25.05";
}
