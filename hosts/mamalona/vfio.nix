{ pkgs, lib, ... }:

{
  # Gestión de aislamiento de GPU limpia y nativa
  boot.initrd.kernelModules = [ "vfio" "vfio_iommu_type1" "vfio-pci" ];
}
