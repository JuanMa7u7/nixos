{ pkgs, inputs, ... }:

{
    home.packages = with pkgs; [
    # ------------------------------- // Software Development
        
        # k8s

        #CLoud
        
        #Tools
        github-cli
        code-cursor
        
        #DB
        mongodb-compass
        mongodb-tools
        
        #langs
        nodejs
    ];
}