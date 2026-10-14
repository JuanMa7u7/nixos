{ inputs, hostName, pkgs, lib, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  pkgsEdge = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./system
  ];

  networking.hostName = hostName;

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
      pkgs-edge = pkgsEdge;
      pkgs-locked = pkgs;
    };

    users."juan_ma7u7" = {
      imports = [
        ./hm
        ../hosts/${hostName}/home.nix
        ../hosts/${hostName}/hm
      ];
    };
  };

  system.stateVersion = "25.05";
}
