{ ... }:
{
  # Compatibility shims for upstream inputs lagging behind nixpkgs-unstable.
  nixpkgs.overlays = [
    (final: prev: {
      # soymou/illogical-flake home-modules/packages.nix still references
      # gnome-icon-theme, which nixpkgs removed (unmaintained, GTK2-based).
      # adwaita-icon-theme (already in the flake's package set) is the
      # maintained successor for GNOME icon coverage. Drop this once upstream
      # removes the reference.
      gnome-icon-theme = prev.adwaita-icon-theme;
    })
  ];
}
