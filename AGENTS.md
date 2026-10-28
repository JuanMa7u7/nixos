# Agent Instructions

This file is the primary guidance for AI agents modifying this repository. Treat the checked-in Nix expressions and scripts as the source of truth; use [the architecture reference](docs/ARCHITECTURE.md) for the module map and host distinctions.

## Repository purpose and architecture

This repository defines NixOS configurations for three `x86_64-linux` hosts: `thinkpad-l15`, `mamalona`, and the not-yet-deployed `homelab` template. The flake's `mkHost` function combines shared modules with each host's hardware and configuration files. `common/default.nix` imports `common/system/` for all hosts and Home Manager for desktop hosts; `homelab` opts out of Home Manager and adds `common/server/`.

The current account name is defined once as `userName = "juan_ma7u7"` in `flake.nix` and passed to NixOS modules as a special argument. Home Manager modules should use `config.home.username` or `config.home.homeDirectory` for user-specific values. Keep the account name consistent across every host.

Important paths:

| Path | Purpose |
|---|---|
| `flake.nix`, `flake.lock` | Inputs, `mkHost`, host outputs, and the standalone Plymouth package output. |
| `common/default.nix` | Shared NixOS entry point, account/Home Manager setup, shared module imports. |
| `common/system/` | Shared system modules: Hyprland/greetd, audio, Plymouth, keyring, fonts, OpenRGB, Owly, and common services/settings. |
| `common/hm/` | Shared Home Manager setup, programs, categorized packages, app modules, session services, and deployed configuration files. |
| `common/server/` | Homelab-only headless, networking, and OCI service modules. |
| `hosts/<name>/` | Per-host hardware file, NixOS configuration, and optional local HM/system modules. |
| `hosts/*/hm/host/` | Per-host Hyprland Lua fragments for monitors, keybindings, and startup commands. |
| `packages/` | Local Nix derivations for `og-xbox-plymouth`, `owly`, and `piik`. |
| `assets/boot.webm` | Tracked source media for the Plymouth theme. It is Microsoft IP and is retained for local personal use; do not redistribute it. |
| `rebuild-*.sh`, `common-rebuild-commands.sh` | Host-specific switch scripts and their shared Hyprland reload helper. |
| `docs/ARCHITECTURE.md` | Detailed module graph, host differences, packaging patterns, and operational risks. |

The actively deployed trees in `common/hm/confs/` are `zen/`, `btop/`, `fastfetch/`, and `opencode/`, as declared by `common/hm/confs/default.nix`. `starship.toml` is retained as the source for an intentionally disabled module. The nested `common/hm/confs/opencode/AGENTS.md` is deployed as OpenCode configuration; it is not the repository's architecture guide.

## Mandatory agent workflow

For every requested change:

1. Inspect `git status --short` and the existing diff; preserve all user work.
2. Read this file, the relevant README/architecture sections, and any more-specific instructions that apply to the target files.
3. Identify the target host, source-of-truth files, module imports, package/runtime dependencies, and cross-host effects. Do not assume a module is shared or a file is unused without tracing references.
4. For substantial work, state the intended behavior, affected files, acceptance criteria, and risks before editing. Ask before making consequential assumptions.
5. Make the smallest coherent change in the existing architecture.
6. Run appropriate non-destructive checks; distinguish evaluation, building, and activation.
7. Review the complete diff and verify that unrelated files, host behavior, and executable permissions were not changed.
8. Report files changed, exact checks and results, unverified behavior, and remaining risks.

Substantial behavior changes should follow the repository's spec-driven workflow: document behavior, scenarios, acceptance criteria, design, tasks, and validation before implementation. Do not mark work complete merely because files were edited.

## Nix-specific rules

- Follow the existing Nix module and formatting style in neighboring files. No repository formatter configuration was found; do not reformat unrelated expressions.
- Use `flake.nix` and `flake.lock` to understand the actual inputs and targets. Nixpkgs is pinned through the `nixos-unstable` flake input; check option availability against the locked revision rather than assuming an option from current unstable documentation.
- Keep shared system settings under `common/system/`, shared desktop/user settings under `common/hm/`, homelab settings under `common/server/`, and hardware/host-specific changes under the matching `hosts/<name>/` directory.
- `common/hm/` is applied to the two desktop hosts, not `homelab`. The server imports `common/server/`, which force-disables parts of the shared desktop stack. Review the merged result before changing shared options.
- The canonical user variable is `userName` in `flake.nix`; do not add new hardcoded account names. In Home Manager modules prefer `config.home.username`/`config.home.homeDirectory`.
- Reuse existing package modules and custom derivations before adding declarations. Check `common/hm/packages/default.nix`, `common/hm/programs/default.nix`, and `packages/` to avoid duplicate package installs or conflicting options.
- Do not change `flake.lock`, update Nixpkgs, or add inputs unless the task requires it. If an input changes, explain why and inspect the resulting lock diff for unrelated revision changes.
- Preserve fixed hashes and reproducibility for fetched sources. Never remove a hash to make a fetch succeed.
- Do not put machine-specific disk IDs, display layouts, driver settings, credentials, or other host-only values in shared modules unless every host needs them.

## AppImage and downloaded application rules

- Follow nearby modules in `common/hm/programs/`. Before editing, verify the source URL, version, architecture, and fixed hash. Many modules use `pkgs.appimageTools.wrapType2`; some instead extract contents or use a custom wrapper/FHS environment.
- Preserve runtime libraries (`extraPkgs`, `runtimeLibs`, or FHS inputs), launcher environment variables, executable names, desktop entries, icons, and MIME associations that the existing application requires.
- Update the version/URL and hash together. Validate with a Nix build of the specific package after reviewing the upstream release source; builds may download artifacts and consume disk/network resources.
- Do not routinely download and execute artifacts manually. Do not replace a Nix package with an AppImage or the reverse without an explicit requirement.
- Some modules are intentionally commented out in `common/hm/programs/default.nix` (`pass`, `starship`, `curseforge`, `pencil`, `xodus`). Keep those files and disablement comments unless the user requests their removal or re-enablement.
- `packages/` contains non-AppImage local derivations too; check its existing patterns before adding a new one.

## Hyprland, Kitty, and desktop configuration

- The active Hyprland base configuration comes from the `illogical-flake` Home Manager module, copied by `copyIllogicalImpulseConfigs`. Do not treat the old vendored Hyprland tree as authoritative; it has been removed.
- Shared custom Lua sources are `common/hm/variables.lua` and `common/hm/appearance.lua`; the repository-owned screen-recording script is `common/hm/scripts/record.sh`. Host fragments are under `hosts/<name>/hm/host/{monitors,keybinds,execs}.lua` and are applied by `hosts/<name>/hm/host.nix` after the upstream copy. Edit these tracked sources, not generated files under `~/.config/hypr`.
- Preserve monitor identifiers/modes, workspace rules, keybindings, startup commands, environment variables, and ordering unless the request requires a change. `custom/general.lua` and `custom/keybinds.lua` receive appended fragments; `custom/execs.lua` is copied as a complete host-owned file.
- Consider the configured greetd/tuigreet session, Hyprland portals, PipeWire/WirePlumber, geoclue, launchers, and host-specific graphics drivers when changing desktop behavior. Do not invent integrations that are not present.
- The NixOS `programs.hyprland` module supplies the Hyprland and GTK portal implementations. Avoid adding duplicate packages to `xdg.portal.extraPortals`; duplicate service units can fail the `user-units` build.
- Kitty is configured by `common/hm/programs/kitty.nix`. Its theme include is generated by quickshell; `common/hm/illogical.nix` restores the HM-managed Kitty config after the upstream activation copy. Preserve the font, settings, include, and remote-control conventions.
- `hyprctl reload` is the post-step in the desktop rebuild helper. It does not establish that every quickshell or session change reloads live; state when a logout/restart may be required but has not been verified. Use available syntax/option checks only when compatible with installed versions.

## Shell script safety

- Identify the target host and read the whole script before editing or executing it. Preserve executable modes and existing interfaces.
- The two rebuild scripts target fixed outputs: `rebuild-thinkpad-l15.sh` targets `thinkpad-l15`, and `rebuild-mamalona.sh` targets `mamalona`. They expect to be run from the repository root. `-s` skips their default `*.nixbak` cleanup; it is **not** a dry-run flag. Without `-s`, each script deletes matching files recursively under the invoking user's home directory.
- Both rebuild scripts use `sudo nixos-rebuild switch`; this activates the configuration and changes the system's boot default. The tracked Plymouth asset is referenced relative to the flake root, so it does not require `--impure`. There is no homelab rebuild script.
- The rebuild scripts currently lack fail-fast handling and do not verify the current hostname/repository directory; do not silently redesign them. Warn about this behavior and propose a separate focused safeguard if relevant.
- Never execute a rebuild/switch, `sudo`, reboot, bootloader operation, hardware change, or other system-changing script without explicit user authorization. Do not run `play-xbox.sh` during validation: it stops the desktop/audio session, kills processes, unbinds NVIDIA devices, and starts the single-GPU VM.
- `attach-multimedia.sh` attaches USB devices to the Windows VM; monitor scripts change the live Hyprland display layout. These are operational actions, not tests.
- Quote shell variables, preserve error handling, avoid destructive cleanup and automatic reboot changes, and use `sh -n`/`bash -n` or static review instead of executing scripts.
- Describe `nixos-rebuild build`/`nix build` as build-only, `nixos-rebuild test` as a temporary activation, and `nixos-rebuild switch` as system activation plus boot-default change. Do not conflate them.

## Validation and testing

Verified read-only evaluation commands from the repository root:

```sh
nix eval --raw .#nixosConfigurations.thinkpad-l15.config.networking.hostName
nix eval --raw .#nixosConfigurations.mamalona.config.networking.hostName
nix eval --raw .#nixosConfigurations.homelab.config.networking.hostName
nix eval --raw .#packages.x86_64-linux.og-xbox-plymouth.name
```

These pure evaluation commands were observed to work with Nix 2.34.8 during the audit. Evaluation is not a hardware test.

The flake has no custom `checks` output. An optional flake-level evaluation is `nix flake check --no-build`; it was not run during the audit and is not a hardware or functional test.

For a build-only system derivation (not run during the audit):

```sh
nix build --no-link .#nixosConfigurations.mamalona.config.system.build.toplevel
```

Replace `mamalona` with the intended host when needed. This can fetch inputs, build many packages, and consume significant time, network, and disk; it does not activate the result. No project-specific `checks` output or formatter configuration was found. `nixfmt` and `shellcheck` were unavailable during the audit. Check tool availability before using optional formatters/static analyzers. Never use `nixos-rebuild test` or `switch` as a validation shortcut without explicit authorization.

## Security and sensitive information

- Never commit passwords, tokens, keys, API credentials, private SSH material, or secret values. Do not copy credentials into documentation or logs. The homelab authorized-key entry is an explicit placeholder and must be replaced with the owner's real public key before a first deployment; do not include the real key in docs.
- Do not weaken firewall, SSH, authentication, boot security, or privileged services without understanding and explaining the effects.
- Keep AppImage/download integrity hashes. Do not execute untrusted downloaded binaries.
- `assets/boot.webm` is tracked but unfree Microsoft media; do not redistribute it or recommend adding similar proprietary media.
- Treat `hosts/mamalona/virt.nix`'s VNC listener/firewall configuration, the broad `xhost` fallback in the BluCast runner, and `luban.nix`'s deletion of its Wine prefix as consequential existing behavior. Review before changing; do not expand exposure or data deletion.
- Do not print or reproduce machine-specific filesystem UUIDs, private host data, or secret values in documentation. Document only facts needed to explain ownership and workflows.

## Change management

- Keep changes scoped to the request. Do not rename, refactor, update dependencies, or delete features for style alone.
- Before removing a file/module/input, trace references in imports, flake outputs, scripts, generated configuration, and documentation. Respect intentional commented-out module entries.
- Preserve unrelated working-tree changes and user modifications. Review `git diff` for host leakage and executable-mode changes.
- Update README/architecture docs whenever a command, path, host responsibility, package pattern, or operational workflow changes.
- Identify possible effects on both desktop hosts and the headless template. State explicitly when a host-specific behavior or hardware result could not be verified.

## Uncertainty and local instructions

- Label facts as observed, inferred, or unknown. Do not invent host hardware, package availability, command options, dependencies, or deployment success.
- If evidence is insufficient, choose the least disruptive option and ask before making a consequential assumption. Record unresolved items as recommendations, not verified behavior.
- Keep this root file as the repository's main agent guide. Do not add more nested instructions without a distinct need. `common/hm/confs/opencode/AGENTS.md` is intentionally part of the deployed OpenCode config; inspect it when editing that application-specific subtree, while applying this root guide to repository work.
