---
description: Validate a NixOS flake/host build without activating it
agent: nixos-admin
---

Validate this target (host name or flake reference):

$ARGUMENTS

Inspect the repository and select appropriate checks: `nix flake check`, targeted `nix eval`, `nix build`, or `nixos-rebuild build --flake`. Do not run switch, boot, garbage collection, or activation. Report exact commands and actual results.
