{ config, pkgs, ... }: {
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
  environment.systemPackages = with pkgs; [
    postgresql
  ];
}