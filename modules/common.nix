{ inputs, hostName, pkgs, ... }:
{
  networking.hostName = hostName;

  imports = [
    inputs.hydenix.inputs.home-manager.nixosModules.home-manager
    inputs.hydenix.nixosModules.default
    ./system
  ];

  # Prisma env (usa pkgs normal)
  environment.sessionVariables = {
    PRISMA_FMT_BINARY = "${pkgs.prisma-engines}/bin/prisma-fmt";
    PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
    PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
    PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
    PRISMA_INTROSPECTION_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/introspection-engine";
  };

  users.users."juan_ma7u7" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "docker" ];
    shell = pkgs.zsh;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-bak";
    backupCommand = pkgs.writeShellScript "hm-backup-existing-file" ''
      target_path="$1"
      backup_ext="''${HOME_MANAGER_BACKUP_EXT:-hm-bak}"
      timestamp="$(${pkgs.coreutils}/bin/date +%Y%m%d-%H%M%S)"
      backup_path="''${target_path}.''${backup_ext}.''${timestamp}"
      counter=0

      while [ -e "$backup_path" ]; do
        counter=$((counter + 1))
        backup_path="''${target_path}.''${backup_ext}.''${timestamp}.''${counter}"
      done

      ${pkgs.coreutils}/bin/mv -- "$target_path" "$backup_path"
    '';
    extraSpecialArgs = {
      inherit hostName inputs;
    };

    users."juan_ma7u7" = {
      imports = [
        inputs.hydenix.homeModules.default
        ./hm
        ../hosts/${hostName}/home.nix
      ];
    };
  };

  hydenix = {
    enable = true;
    hostname = hostName;

    timezone = "America/Mexico_City";
    locale = "en_US.UTF-8";

    boot = {
      enable = true;
      useSystemdBoot = true;
      grubTheme = "Retroboot";
      grubExtraConfig = "";

      kernelPackages = pkgs.linuxPackages_zen;
    };

    gaming.enable = true;
    hardware.enable = true;
    network.enable = true;
    nix.enable = true;

    sddm.enable = true;
    system.enable = true;
  };

  system.stateVersion = "25.05";
}
