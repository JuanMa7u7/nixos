{ pkgs, inputs, config, lib, ... }:
let
  # pyamdgpuinfo gives the AMD path in gpuinfo.sh real data instead of falling
  # back to the generic sensors output. It is optional because some pinned
  # nixpkgs revisions might not expose the attribute.
  pythonWithAmd =
    let pyamdgpuinfo = pkgs.python3Packages.pyamdgpuinfo or null;
    in pkgs.lib.optional (pyamdgpuinfo != null)
         (pkgs.python3.withPackages (ps: [ ps.pyamdgpuinfo ]));
in
{
  home.packages =
    (with pkgs; [
      # ------------------------------- // Software Development

      # k8s

      #CLoud

      #Tools
      github-cli
      opencode
      td
      tmux
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
      go
      (lib.hiPrio flutter)
    ]) ++ pythonWithAmd;
}
