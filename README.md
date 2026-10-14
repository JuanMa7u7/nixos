# NixOS Configuration

This repository manages two NixOS hosts with a shared Hyprland + Caelestia desktop layer:

- `thinkpad-l15`: laptop-oriented profile
- `mamalona`: desktop profile with Nvidia-specific configuration, VFIO/VM, gaming

## Layout

- `flake.nix`: host definitions and shared inputs
- `common/default.nix`: host assembly (imports system config + home-manager bootstrap)
- `common/system/`: shared system-wide configuration (boot, hardware, networking, services, users)
- `common/hm/`: shared Home Manager configuration (programs, packages, services, raw config files, Caelestia settings)
- `hosts/<name>/configuration.nix`: host-specific NixOS settings
- `hosts/<name>/home.nix`: host-specific Home Manager settings
- `hosts/<name>/hm/`: host-specific Home Manager configuration (monitor layout, etc.)
- `hosts/<name>/system.nix`: host-local system fragments when needed

## Caelestia Shell

Caelestia Shell is consumed as a GitHub flake input (`github:JuanMa7u7/caelestia-shell`).
The `caelestia-shell/` directory is a git submodule containing the source for reference and local customization.

Per-host Caelestia customization (monitor layout, gifs) lives under `hosts/<name>/hm/confs/caelestia/`.

## Conventions

- Hardware-specific drivers, mounts, and quirks belong inside the relevant host directory.
- NVIDIA, gaming, and VFIO configuration belongs only to `mamalona`.
- Shared modules should stay hardware-agnostic unless every host needs the same behavior.
- Some legacy/unused modules are preserved under `common/hm/` as inactive references (e.g., `hydenix.nix`, `gh-repos.nix`, `opencode.nix`, and upstream Arch leftovers under `confs/`).

## Boot splash (OG Xbox)

- `common/system/plymouth.nix`: enables Plymouth with a custom `og-xbox` theme built from `assets/boot.webm` (1920x1080 @60fps, full clip) plus a systemd service playing the clip audio after the sound stack is up. Boot menus stay visible; the animation runs after entry selection.
- `assets/boot.webm` is gitignored (Microsoft IP, local personal use) and referenced by absolute path, so rebuilds require `--impure` — use `./rebuild-mamalona.sh` / `./rebuild-thinkpad-l15.sh`.
- 60fps trade-off: boot-entry retention is force-lowered to 3 (`configurationLimit`) to fit the ~81MB initrds on the small `/boot` partitions.
- Preview without rebooting: `sudo plymouthd; sudo plymouth --show-splash; sleep 11; sudo plymouth --quit`.

## Common Commands

```bash
./rebuild-thinkpad-l15.sh
./rebuild-mamalona.sh
```
