# =============================================================================
# PLACEHOLDER / TEMPLATE — HP Pavilion dm1 (AMD E-350, SA400 SSD, Realtek GbE)
# =============================================================================
# This file is a stand-in so the flake evaluates. It is NOT a real
# hardware-configuration.nix. On the target machine, replace it with:
#
#     nixos-generate-config --show-hardware-config \
#       > hosts/homelab/hardware-configuration.nix
#
# This file (plus the boot.loader block in configuration.nix if the machine is
# EFI) is the ONLY thing that needs to change when migrating to new hardware.
# =============================================================================
{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # AMD EHCI/OHCI USB + AHCI SATA for the old Zacate platform; Realtek r8169
  # and AHCI are built into the kernel.
  boot.initrd.availableKernelModules = [ "ahci" "sd_mod" "sr_mod" "usb_storage" "ehci_pci" "ohci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # Placeholder root filesystem on the Kingston SA400 SATA SSD. The real
  # device (UUID/label) is filled in by nixos-generate-config.
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  swapDevices = [ ];

  # AMD E-350 (Bobcat) — load the AMD microcode.
  hardware.cpu.amd.updateMicrocode = true;
}
