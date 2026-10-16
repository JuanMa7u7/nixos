{ ... }:
{
  # Homelab-only system stack. Imported by the `homelab` host via mkHost's
  # extraModules (see flake.nix) so desktop hosts never see any of this.
  imports = [
    ./server-base.nix
    ./networking.nix
    ./services
  ];
}
