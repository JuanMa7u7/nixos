---
name: nixos-administration
description: Use for NixOS, Nix flakes, Nix language, NixOS modules, Home Manager, nixpkgs, system generations, and declarative host configuration.
---

# NixOS Administration

## Source of truth
- Inspect `flake.nix`, `flake.lock`, host definitions, module imports, and Home Manager configuration first.
- Identify the exact host and pinned nixpkgs revision.
- Verify options/packages against that revision; online current docs may differ.
- Mark facts as observed, inferred, or unknown.

## Design principles
- Prefer declarative and reproducible configuration.
- Follow existing module boundaries and naming.
- Minimize overlays and package overrides.
- Avoid imperative fixes when a declarative module is appropriate.
- Do not duplicate existing options or modules.

## Investigation and validation
Use targeted commands such as:
- `nix flake metadata`
- `nix flake show`
- `nix eval`
- `nix flake check`
- `nix build`
- `nixos-rebuild build --flake .#HOST`

Do not run activation (`switch`/`boot`), garbage collection, or destructive operations without explicit approval. Never claim validation succeeded unless the command completed and output was checked.

## Change report
Explain target host, files changed, why the change is needed, validation commands, activation impact, risks, and rollback.
