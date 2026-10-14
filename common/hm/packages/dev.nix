{ pkgs, pkgs-edge, lib, ... }:
let
  stablePkgs = with pkgs; [
    git-lfs
    kubectl
    lens
    kubernetes-helm
    doctl
    ngrok
    bootdev-cli
    lmstudio
    # n8n
    aria2
    bat
    btop
    curl
    anydesk
    fd
    ripgrep
    lsof
    fzf
    socat
    ffmpeg
    docker-compose
    process-compose
    jq
    lazygit
    code-cursor
    postman
    insomnia
    pandoc
    speedtest-cli
    stripe-cli
    sshfs
    tree-sitter
    tree
    zoxide
    uutils-coreutils-noprefix
    sqlite
    sqlitebrowser
    # mongodb-compass  # temporarily disabled - nixpkgs issue
    mongodb-tools
    # nodejs
    gjs
    just
    bun
    cargo
    uv
    # python3 removed: soymou/illogical-flake already provides a
    # python3.withPackages env (programs.illogical-impulse); keeping plain
    # python3 alongside it breaks home-manager buildEnv with:
    #   conflicting subpath `bin/idle3.14'
    # go
    gcc
    gnumake
    cmakeMinimal
    typescript
    eslint
    dbeaver-bin
    go_1_26
    libgcc
    nodejs_22
    openssl
    opencode
    pnpm_10
    prisma
    prisma-engines
    turbo
    tmux
    vscode
    flutter
    direnv
    tabularis
  ];
  edgePkgs = with pkgs-edge; [
    github-cli
    jetbrains-toolbox
    neovim
  ];
in
{
  home.packages = stablePkgs ++ edgePkgs;
}
