---
name: linux-hardware-debugging
description: Use for Linux kernel, systemd, NVIDIA, Vulkan, Wayland, Hyprland, displays, USB, Bluetooth, audio, networking, and hardware troubleshooting.
---

# Linux Hardware Debugging

Diagnose before modifying. Identify distribution, kernel, session type, hardware, and affected subsystem. On NixOS, distinguish declarative configuration from runtime state.

## Useful read-only evidence
- `uname -a`, `nixos-version`
- `lspci -nnk`, `lsusb`
- `lsmod`, `dmesg`, `journalctl -b`
- `systemctl --failed`, `systemctl status NAME`
- `nvidia-smi`, `vulkaninfo --summary`
- `ip addr`, `ip route`, `resolvectl status`
- `wpctl status`, `pactl info`
- `hyprctl monitors`, `hyprctl devices`, `hyprctl systeminfo`

Run only commands relevant to the symptom. Do not dump all logs or environment variables.

## Reasoning
1. Reproduce/clarify symptom and timing.
2. Gather the smallest useful evidence.
3. Build hypotheses and test them with read-only checks.
4. Identify confirmed cause versus uncertainty.
5. Recommend the smallest reversible fix.

Ask before changing kernel/driver/boot configuration, restarting/stopping critical services, or modifying system state. Include validation and rollback.
