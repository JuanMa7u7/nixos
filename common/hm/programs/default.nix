{ ... }:
{
  imports = [
    ./git.nix
    ./tmux.nix
    # ./pass.nix
    ./direnv.nix
    ./vscode.nix
    ./zsh.nix
    ./kitty.nix
    ./foot.nix
    ./starship.nix
    ./responsively.nix
    # ./curseforge.nix
    ./duckstation.nix
    ./shadps4.nix
    ./affinity.nix
    # ./pencil.nix  # TEMPORARILY DISABLED — hash mismatch on AppImage
    ./luban.nix
    ./real-video-enhancer.nix
    # ./xodus.nix
  ];
}
