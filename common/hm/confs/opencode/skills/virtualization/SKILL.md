---
name: virtualization
description: Use for KVM, QEMU, libvirt, VFIO, IOMMU, PCI/GPU/USB passthrough, OVMF, VirtIO, and Proxmox.
---

# Linux Virtualization

## Discovery
Inspect CPU virtualization support, IOMMU enablement/groups, PCI IDs, bound drivers, libvirt state, VM XML, storage pools, networks, and host device dependencies.

Useful read-only commands include:
- `lscpu`
- `lspci -nnk`
- `find /sys/kernel/iommu_groups/ -type l`
- `virsh list --all`
- `virsh dominfo VM`
- `virsh dumpxml VM`
- `lsusb`
- `ls -l /dev/kvm`

## GPU passthrough
Verify both GPU and audio functions, IOMMU group isolation, VFIO binding, host display dependencies, firmware/OVMF, guest driver state, reset behavior, and recovery path.

## USB passthrough
Identify vendor/product IDs and controller topology. Protect host-critical keyboard, mouse, audio, webcam, Bluetooth, and storage devices. Consider passing through a dedicated USB controller only after verifying its IOMMU grouping and host dependencies.

## Safety
Never detach devices or alter kernel/initrd/boot parameters without approval. Never stop/destroy VMs or modify virtual disks without approval. Provide host impact, guest impact, downtime, validation, and rollback.
