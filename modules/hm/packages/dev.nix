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
        nodePackages_latest.pnpm
        nodePackages_latest.vercel
        nodePackages_latest.prisma
    ];
}