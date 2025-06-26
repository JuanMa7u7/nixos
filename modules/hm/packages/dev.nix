{ pkgs, inputs, ... }:

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
    ];
}