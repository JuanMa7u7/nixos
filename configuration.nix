{
  config,
  pkgs,
  inputs,
  ...
}:
let
  # Package declaration
  # ---------------------

  pkgs = import inputs.hydenix.inputs.hydenix-nixpkgs {
    inherit (inputs.hydenix.lib) system;
    config.allowUnfree = true;
    overlays = [
      inputs.hydenix.lib.overlays
    ];

    # Include your own package set to be used eg. pkgs.userPkgs.bash
    userPkgs = inputs.nixpkgs {
      config.allowUnfree = true;
    };
  };
in
{
  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [80 443 445 3000];
    allowPing = true;
  };

  # Samba
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "smbnix";
        "netbios name" = "smbnix";
        "security" = "user";
        #"use sendfile" = "yes";
        #"max protocol" = "smb2";
        # note: localhost is the ipv6 localhost ::1
        "hosts allow" = "192.168.117. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      "NixOS-Share" = {
        "path" = "/home/juan_ma7u7";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        # "force user" = "username";
        # "force group" = "groupname";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  # PostgreSQl
  services.postgresql = {
    enable = true;
    # Versión de PostgreSQL que quieres usar (por ejemplo, 16 o 17).
    # Puedes omitir esta línea para usar la versión predeterminada de tu Nixpkgs.
    # package = pkgs.postgresql_16; 

    # Nombres de las bases de datos que quieres que se creen automáticamente al iniciar el servicio.
    ensureDatabases = [ "mydatabase" ]; 

    # Configuración de autenticación (pg_hba.conf).
    # Esta es una configuración muy básica que permite el acceso local a todas las bases de datos
    # para todos los usuarios sin contraseña (método 'trust'). 
    # ¡ADVERTENCIA! Para producción, DEBES configurar una autenticación más segura.
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
    '';

    # Si quieres permitir conexiones TCP/IP (por defecto están deshabilitadas por seguridad).
    # enableTCPIP = true;
    port = 5432; # Puerto por defecto de PostgreSQL

    # Puedes agregar configuración adicional de PostgreSQL aquí (postgresql.conf)
    # extraConfig = ''
    #   max_connections = 100
    #   shared_buffers = 128MB
    # '';
  };

  # Opcional: Para poder interactuar con PostgreSQL desde la línea de comandos
  # con herramientas como `psql`, puedes agregarlas a tus paquetes de sistema.
  # environment.systemPackages = with pkgs; [
  #     postgresql
  # ];

  # Set pkgs for hydenix globally, any file that imports pkgs will use this
  nixpkgs.pkgs = pkgs;

  imports = [
    inputs.hydenix.inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
    inputs.hydenix.lib.nixOsModules
    ./modules/system

    # === GPU-specific configurations ===

    /*
      For drivers, we are leveraging nixos-hardware
      Most common drivers are below, but you can see more options here: https://github.com/NixOS/nixos-hardware
    */

    #! EDIT THIS SECTION
    # For NVIDIA setups
    # inputs.hydenix.inputs.nixos-hardware.nixosModules.common-gpu-nvidia

    # For AMD setups
    # inputs.hydenix.inputs.nixos-hardware.nixosModules.common-gpu-amd

    # === CPU-specific configurations ===
    # For AMD CPUs
    inputs.hydenix.inputs.nixos-hardware.nixosModules.common-cpu-amd

    # For Intel CPUs
    # inputs.hydenix.inputs.nixos-hardware.nixosModules.common-cpu-intel

    # === Other common modules ===
    inputs.hydenix.inputs.nixos-hardware.nixosModules.common-pc
    inputs.hydenix.inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "nixbak";
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
    };

    #! EDIT THIS USER (must match users defined below)
    users."juan_ma7u7" =
      { ... }:
      {
        imports = [
          inputs.hydenix.lib.homeModules
          # Nix-index-database - for comma and command-not-found
          inputs.nix-index-database.hmModules.nix-index
          ./modules/hm
        ];
      };
  };

  # IMPORTANT: Customize the following values to match your preferences
  hydenix = {
    enable = true; # Enable the Hydenix module

    #! EDIT THESE VALUES
    hostname = "Lenovo-ThinkpPad-L15"; # Change to your preferred hostname
    timezone = "America/Mexico_City"; # Change to your timezone
    locale = "en_US.UTF-8"; # Change to your preferred locale

    /*
      Optionally edit the below values, or leave to use hydenix defaults
      visit ./modules/hm/default.nix for more options

      audio.enable = true; # enable audio module
      boot = {
        enable = true; # enable boot module
        useSystemdBoot = true; # disable for GRUB
        grubTheme = pkgs.hydenix.grub-retroboot; # or pkgs.hydenix.grub-pochita
        grubExtraConfig = ""; # additional GRUB configuration
        kernelPackages = pkgs.linuxPackages_zen; # default zen kernel
      };
      gaming.enable = true; # enable gaming module
      hardware.enable = true; # enable hardware module
      network.enable = true; # enable network module
      nix.enable = true; # enable nix module
      sddm = {
        enable = true; # enable sddm module
        theme = pkgs.hydenix.sddm-candy; # or pkgs.hydenix.sddm-corners
      };
      system.enable = true; # enable system module
    */
  };

  #! EDIT THESE VALUES (must match users defined above)
  users.users."juan_ma7u7" = {
    isNormalUser = true; # Regular user account
    initialPassword = "hydenix"; # Default password (CHANGE THIS after first login with passwd)
    extraGroups = [
      "wheel" # For sudo access
      "networkmanager" # For network management
      "video" # For display/graphics access
      "docker"
      # Add other groups as needed
    ];
    shell = pkgs.zsh; # Change if you prefer a different shell
  };

  system.stateVersion = "25.05";
}
