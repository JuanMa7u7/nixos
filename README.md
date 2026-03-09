# NixOS Configuration

This repository manages two NixOS hosts with a shared Hydenix + Caelestia desktop layer:

- `thinkpad-l15`: laptop-oriented profile
- `mamalona`: desktop profile with Nvidia-specific configuration

## Layout

- `flake.nix`: host definitions and shared inputs
- `common/default.nix`: shared system and Home Manager bootstrap
- `common/system`: system-wide shared defaults
- `common/hm`: shared Home Manager modules and Caelestia/Hypr configs
- `hosts/<name>/configuration.nix`: host-specific NixOS settings
- `hosts/<name>/home.nix`: host-specific Home Manager settings
- `hosts/<name>/hm`: host-specific Home Manager overrides (monitors, etc.)
- `hosts/<name>/system.nix`: host-local system fragments when needed

## Conventions

- Keep hardware-specific drivers, mounts, and quirks inside the relevant host directory.
- Anything Nvidia-related belongs only to `hosts/mamalona`.
- Shared modules should stay hardware-agnostic unless every host needs the same behavior.

## Common Commands

```bash
sudo nixos-rebuild switch --flake .#thinkpad-l15
sudo nixos-rebuild switch --flake .#mamalona
```
  
