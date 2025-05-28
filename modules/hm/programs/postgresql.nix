{  ... }: {
    programs.postgresql = {
        enable = true;
        package = pkgs.postgresql_11;
        dataDir = "/data/postgresql";
    }
}