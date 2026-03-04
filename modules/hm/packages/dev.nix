{ pkgs, lib, ... }:
{
  home.packages =
    (with pkgs; [
      mongodb-tools
      dbeaver-bin
      gcc
      github-cli
      go_1_26
      libgcc
      nodejs_20
      openssl
      opencode
      pnpm_9
      prisma
      prisma-engines
      tmux
      vscode
      (lib.hiPrio flutter)
    ]);
}
