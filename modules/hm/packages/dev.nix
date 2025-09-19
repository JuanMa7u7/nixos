{ pkgs, inputs, config, lib, ... }:

{
    home.packages = with pkgs; [
    # ------------------------------- // Software Development
        
        # k8s

        #CLoud
        
        #Tools
        github-cli
        # code-cursor
        vscode
        
        #DB
        mongodb-compass
        mongodb-tools
        dbeaver-bin
        
        #langs
        nodejs_20
        pnpm_9
        openssl
        nodePackages_latest.vercel
        prisma
        prisma-engines
    ];

    environment.sessionVariables = with pkgs; {
    PRISMA_FMT_BINARY = "${prisma-engines}/bin/prisma-fmt";
    PRISMA_QUERY_ENGINE_BINARY = "${prisma-engines}/bin/query-engine";
    PRISMA_QUERY_ENGINE_LIBRARY = "${prisma-engines}/lib/libquery_engine.node";
    PRISMA_SCHEMA_ENGINE_BINARY = "${prisma-engines}/bin/schema-engine";
    PRISMA_INTROSPECTION_ENGINE_BINARY = "${prisma-engines}/bin/introspection-engine";
  };
}