{
  config,
  lib,
  pkgs,
  ...
}:

{
  # ═══════════════════════════════════════════════════════════════
  # CONFIGURACIÓN OFICIAL NATIVA DE LIBVIRT EN NIXOS
  # ═══════════════════════════════════════════════════════════════
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    onShutdown = "shutdown";

    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true; # Soporte para Secure Boot / TPM 2.0
      
      # UNIFICADO: Permisos de Root y ACL estricto para Evdev y tus USBs
      verbatimConfig = ''
        vnc_listen = "0.0.0.0"
        vnc_tls = 0
        user = "root"
        group = "root"
        cgroup_device_acl = [
            "/dev/kvm",
            "/dev/kvm-amd",
            "/dev/input/by-id",
            "/dev/null",
            "/dev/urandom",
            "/dev/ptmx",
            "/dev/shm",
            "/dev/rtc0",
            "/dev/bus/usb/001/*",
            "/dev/bus/usb/005/*"
        ]
      '';
    };

    extraConfig = ''
      unix_sock_group = "libvirtd"
      unix_sock_ro_perms = "0777"
      unix_sock_rw_perms = "0770"
      auth_unix_ro = "none"
      auth_unix_rw = "none"
      namespaces = []
      clear_emulator_capabilities = 0
      relaxed_acs_check = 1
      macvtap_management = 1
      keep_alive_required = 0
    '';
  };

  # ═══════════════════════════════════════════════════════════════
  # CONFIGURACIONES DE ENTORNO Y BYPASS DE SYSTEMD
  # ═══════════════════════════════════════════════════════════════

  # Permitir el bloqueo de memoria RAM física ilimitada para QEMU
  systemd.services.libvirtd.serviceConfig.LimitMEMLOCK = lib.mkForce "infinity";

  # Inyectamos una llave de bypass de exactamente 32 bytes de longitud
  systemd.services.libvirtd.serviceConfig.LoadCredential = lib.mkForce [ "secrets-encryption-key:${pkgs.writeText "dummy-key" "12345678901234567890123456789012"}" ];

  # HOOK DE ENERGÍA NATIVO ANFITRION: Reinicia la PC física al apagar Windows de forma síncrona
  virtualisation.libvirtd.hooks.qemu = {
    win11-gaming-hook = pkgs.writeScript "win11-gaming-hook" ''
      #!/bin/sh
      # $1 = Nombre de la VM, $2 = Acción de Libvirt
      if [ "$1" = "win11-vm1-singlegpu" ] && [ "$2" = "stopped" ]; then
        /run/current-system/sw/bin/systemctl reboot
      fi
    '';
  };

  # Registrar los directorios físicos para el hook en NixOS
  systemd.tmpfiles.rules = [
    "d /var/lib/libvirt/hooks 0750 root root -"
    "L+ /var/lib/libvirt/hooks/qemu - - - - /etc/libvirt/hooks/qemu"
  ];

  # Añadir tu usuario a los grupos de gestión de la suite
  users.users.juan_ma7u7.extraGroups = [ "libvirtd" "qemu-libvirtd" "kvm" "audio"];

  # Permitir conexiones de red para VNCViewer en el firewall local
  networking.firewall.allowedTCPPorts = [ 5900 ];
  networking.firewall.allowedUDPPorts = [ 4010 ];

  # Paquetes requeridos del sistema para virtualización gráfica
  environment.systemPackages = with pkgs; [
    virtio-win
    OVMFFull
    spice-gtk
    virt-manager
    scream

    # Script definitivo corregido y libre de bugs de compilación
    (writeShellScriptBin "attach-windows-vm-devices" ''
      URI="qemu:///system?socket=/var/run/libvirt/libvirt-sock"
      VM="win11-vm1-singlegpu"
      
      echo "Iniciando la conexión de dispositivos multimedia con Windows 11 mediante Redirección Dinámica..."

      # 1. PURGA EN CALIENTE: Remover registros viejos de la memoria de QEMU por si acaso
      ${pkgs.libvirt}/bin/virsh -c "$URI" qemu-monitor-command "$VM" '{"execute":"device_del","arguments":{"id":"redir0"}}' 2>/dev/null || true
      ${pkgs.libvirt}/bin/virsh -c "$URI" qemu-monitor-command "$VM" '{"execute":"device_del","arguments":{"id":"redir1"}}' 2>/dev/null || true
      ${pkgs.libvirt}/bin/virsh -c "$URI" qemu-monitor-command "$VM" '{"execute":"chardev-remove","arguments":{"id":"charredir0"}}' 2>/dev/null || true
      ${pkgs.libvirt}/bin/virsh -c "$URI" qemu-monitor-command "$VM" '{"execute":"chardev-remove","arguments":{"id":"charredir1"}}' 2>/dev/null || true
      pkill -9 usbredirserver || true
      sleep 1

      # Inyectar Cámara Razer y Bluetooth por Passthrough estándar
      ${pkgs.libvirt}/bin/virsh -c "$URI" attach-device "$VM" <(echo "<hostdev mode='subsystem' type='usb' managed='yes'><source><vendor id='0x1532'/><product id='0x0e03'/></source></hostdev>") 2>/dev/null || true
      ${pkgs.libvirt}/bin/virsh -c "$URI" attach-device "$VM" <(echo "<hostdev mode='subsystem' type='usb' managed='yes'><source><vendor id='0x0e8d'/><product id='0x0608'/></source></hostdev>") 2>/dev/null || true

      # 🎙️ INYECCIÓN DEL MICRÓFONO HYPERX QUADCAST (0951:16df)
      echo "Redirigiendo Micrófono HyperX QuadCast..."
      ${pkgs.libvirt}/bin/virsh -c "$URI" qemu-monitor-command "$VM" '{"execute":"chardev-add","arguments":{"id":"charredir0","backend":{"type":"socket","data":{"addr":{"type":"inet","data":{"host":"127.0.0.1","port":"4001"}},"server":true}}}}' 2>/dev/null || true
      # Forzamos a QEMU a colgar el dispositivo del hub USB virtual emulado
      ${pkgs.libvirt}/bin/virsh -c "$URI" qemu-monitor-command "$VM" '{"execute":"device_add","arguments":{"driver":"usb-redir","chardev":"charredir0","id":"redir0"}}' 2>/dev/null || true
      sleep 1
      ${pkgs.usbredir}/bin/usbredirserver -p 4001 0951:16df >/dev/null 2>&1 &

      # 🎧 INYECCIÓN DE LOS AUDÍFONOS LOGITECH G733 (046d:0ab5)
      echo "Redirigiendo Audífonos Logitech G733..."
      ${pkgs.libvirt}/bin/virsh -c "$URI" qemu-monitor-command "$VM" '{"execute":"chardev-add","arguments":{"id":"charredir1","backend":{"type":"socket","data":{"addr":{"type":"inet","data":{"host":"127.0.0.1","port":"4002"}},"server":true}}}}' 2>/dev/null || true
      ${pkgs.libvirt}/bin/virsh -c "$URI" qemu-monitor-command "$VM" '{"execute":"device_add","arguments":{"driver":"usb-redir","chardev":"charredir1","id":"redir1"}}' 2>/dev/null || true
      sleep 1
      ${pkgs.usbredir}/bin/usbredirserver -p 4002 046d:0ab5 >/dev/null 2>&1 &

      echo "Operación finalizada. Verifique el Administrador de dispositivos en Windows."
    '')
  ];
}
