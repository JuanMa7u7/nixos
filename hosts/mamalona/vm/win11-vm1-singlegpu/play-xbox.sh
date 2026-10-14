#!/run/current-system/sw/bin/bash
set -x

echo "=== 1. Deteniendo entorno gráfico ==="
sudo systemctl stop display-manager.service
sleep 2

echo "=== 2. Liberando consolas de texto y framebuffer ==="
echo 0 | sudo tee /sys/class/vtconsole/vtcon0/bind 2>/dev/null
echo 0 | sudo tee /sys/class/vtconsole/vtcon1/bind 2>/dev/null
if [ -d /sys/bus/platform/drivers/efi-framebuffer ]; then
    echo "efi-framebuffer.0" | sudo tee /sys/bus/platform/drivers/efi-framebuffer/unbind 2>/dev/null
fi

echo "=== 3. Aniquilando procesos persistentes de NVIDIA ==="
sudo fuser -k -9 /dev/nvidia* 2>/dev/null
sudo pkill -9 -f pipewire 2>/dev/null
sudo pkill -9 -f wireplumber 2>/dev/null
sudo systemctl stop nvidia-persistenced.service 2>/dev/null
sleep 1

echo "=== 4. Desvincular drivers directamente en el bus PCI ==="
# Esto evita que el rmmod secundario cuelgue tu terminal SSH
if [ -e /sys/bus/pci/drivers/nvidia/unbind ]; then
    echo "0000:0b:00.0" | sudo tee /sys/bus/pci/drivers/nvidia/unbind 2>/dev/null
fi
if [ -e /sys/bus/pci/drivers/snd_hda_intel/unbind ]; then
    echo "0000:0b:00.1" | sudo tee /sys/bus/pci/drivers/snd_hda_intel/unbind 2>/dev/null
fi
sleep 1

echo "=== 5. Descargando drivers de la memoria RAM ==="
sudo rmmod nvidia_drm nvidia_modeset nvidia_uvm 2>/dev/null
sudo rmmod nvidia 2>/dev/null
sleep 1

echo "=== 6. Cargando controlador de la máquina virtual (VFIO) ==="
sudo modprobe vfio-pci

echo "=== 7. Levantando servicios e iniciando Windows 11 ==="
sudo systemctl start libvirtd.socket libvirtd.service 2>/dev/null
sleep 1

# Lanzamiento directo forzado al socket tradicional seguro de NixOS
sudo virsh -c "qemu:///system?socket=/var/run/libvirt/libvirt-sock" start win11-vm1-singlegpu

echo "=== PROCESO FINALIZADO: Tu SSH está libre ==="

