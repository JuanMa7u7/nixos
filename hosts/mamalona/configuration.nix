{ lib, pkgs, ... }:
{
  imports = [ ./system.nix ./vfio.nix ./virt.nix ];

  # Bootloader: this machine EFI-boots via systemd-boot remnants (proven by a
  # booted cmdline referencing \EFI\nixos\... paths); the GRUB-to-/dev/sda
  # setup never owned the boot path, so GRUB menu updates were theater and the
  # firmware kept defaulting to a stale July entry. Own systemd-boot instead:
  # fresh entries, newest-first default, old ones pruned by configurationLimit.
  # The orphaned GRUB MBR on /dev/sda stays as a fallback and is not touched.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub.enable = false;
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva-vdpau-driver
      libvdpau-va-gl
      nvidia-vaapi-driver
    ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    protontricks.enable = true;
    extest.enable = true;
    gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.displayManager.sddm.wayland.enable = lib.mkForce false;

  hardware.nvidia = {
    modesetting.enable = true;

    # REQUIRED en drivers >= 560
    open = true;

    nvidiaSettings = true;
  };

  # Evita el assert de PRIME: en desktop no lo uses
  hardware.nvidia.prime = {
    offload.enable = lib.mkForce false;
    sync.enable = lib.mkForce false;
  };

  networking = {
    firewall = {
      enable = true;
      # SOLUCIÓN DE RED: Permitir todo el tráfico interno de la VM sin restricciones de puertos
      trustedInterfaces = [ "virbr0" ];
    };
  };

  # Steam/Proton 32-bit — now merged into hardware.graphics above

  # ═══════════════════════════════════════════════════════════════
  # MENÚ DE ARRANQUE DOBLE REPARADO (Sin aserciones de SDDM)
  # ═══════════════════════════════════════════════════════════════
  specialisation."Windows-Gaming-VM".configuration = {
    system.nixos.tags = [ "VFIO-Windows" ];
    
    services.displayManager.sddm.enable = lib.mkForce false;
    services.displayManager.enable = lib.mkForce false;
    services.greetd.enable = lib.mkForce false; # GPU is VFIO-bound here; no greeter possible
    services.xserver.enable = lib.mkForce false;
    services.xserver.videoDrivers = lib.mkForce [ ];
    hardware.nvidia.modesetting.enable = lib.mkForce false;
    virtualisation.spiceUSBRedirection.enable = true;
    
    virtualisation.libvirtd.enable = lib.mkForce true;
    systemd.sockets.libvirtd.enable = lib.mkForce true;
    systemd.services.libvirtd.enable = lib.mkForce true;

    hardware.nvidia-container-toolkit.enable = lib.mkForce false;
    hardware.nvidia-container-toolkit.suppressNvidiaDriverAssertion = lib.mkForce true;

    boot.blacklistedKernelModules = [ "nvidia" "nvidia_drm" "nvidia_modeset" "nvidia_uvm" "nouveau" ];

    boot.kernelParams = [
      "amd_iommu=on"
      "iommu=pt"
      "kvm.ignore_msrs=1"
      "kvm.report_ignored_msrs=0"
      "pcie_aspm=off"
      "vfio-pci.ids=10de:2703,10de:22bc"
      "video=efifb:off"
      "video=vesafb:off"
      "hugepagesz=2M"
      "hugepages=12288" # Esto solo se activará cuando elijas el perfil de Windows en el GRUB
    ];

    boot.initrd.kernelModules = [ "vfio" "vfio_iommu_type1" "vfio-pci" ];

    # Servicio de auto-arranque avanzado con bloqueo de drivers USB nativos
    systemd.services.auto-start-windows-vm = {
      description = "Arrancar Windows 11 VM automaticamente en Modo Juego";
      wantedBy = [ "multi-user.target" ];
      after = [ "libvirtd.service" ];
      requires = [ "libvirtd.service" ];
      
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";
        # REMOVIDO SCREAM DE AQUÍ: El arranque ahora es puramente de Libvirt
        ExecStart = "${pkgs.bash}/bin/bash -c 'sleep 5; ${pkgs.libvirt}/bin/virsh -c qemu:///system?socket=/var/run/libvirt/libvirt-sock net-start default 2>/dev/null; ${pkgs.libvirt}/bin/virsh -c qemu:///system?socket=/var/run/libvirt/libvirt-sock start win11-vm1-singlegpu'";
      };
    };
  };

  boot.kernelModules = [ "v4l2loopback" ];

  # v4l2loopback configuration for BluCast virtual camera
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=10 card_label="BluCast Virtual Camera" exclusive_caps=1 max_buffers=2 max_openers=10
  '';

  # Elgato 4K60 Pro capture card driver (sc0710)
  hardware.sc0710.enable = true;

  # Reglas de Udev unificadas en un solo bloque de texto plano de Nix
  services.udev.extraRules = ''
    SUBSYSTEM=="video4linux", ATTR{name}=="BluCast Virtual Camera", MODE="0666", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0951", ATTR{idProduct}=="16df", MODE="0666", GROUP="libvirtd", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTR{idVendor}=="1532", ATTR{idProduct}=="0e03", MODE="0666", GROUP="libvirtd", TAG+="uaccess"
    
    # Micrófono HyperX QuadCast (0951:16df)
    SUBSYSTEM=="usb", ATTR{idVendor}=="0951", ATTR{idProduct}=="16df", MODE="0666", GROUP="kvm"

    # Audífonos Logitech G733 (046d:0ab5)
    SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="0ab5", MODE="0666", GROUP="kvm"

    # Cámara Razer Kiyo (1532:0e03)
    SUBSYSTEM=="usb", ATTR{idVendor}=="1532", ATTR{idProduct}=="0e03", MODE="0666", GROUP="kvm"

    # Antena Bluetooth MediaTek (0e8d:0608)
    SUBSYSTEM=="usb", ATTR{idVendor}=="0e8d", ATTR{idProduct}=="0608", MODE="0666", GROUP="kvm"
  '';

  hardware.nvidia-container-toolkit = {
    enable = false;
  };

  security.sudo.extraRules = [
    {
      users = [ "juan_ma7u7" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/systemctl reboot";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
