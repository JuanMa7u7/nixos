{ pkgs, lib, ... }:
let
  # NOTE: absolute path (not ../.. relative) is deliberate. assets/boot.webm
  # is gitignored (Microsoft IP, local personal use only) and flakes only see
  # git-tracked files via relative paths — an absolute path literal is still
  # copied to the store and works.
  videoPath = /home/juan_ma7u7/nixos/assets/boot.webm;
  themePkg = pkgs.callPackage ../../packages/og-xbox-plymouth {
    srcVideo = videoPath;
  };
in
{
  boot.plymouth = {
    enable = true;
    theme = "og-xbox";
    themePackages = [ themePkg ];
  };

  # Silent phase after the boot entry is chosen (menu itself stays visible).
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.kernelParams = [
    "quiet"
    "splash"
    "rd.systemd.show_status=auto"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
  ];

  # Approved 60fps trade-off: the 1080p60 frame set adds ~100MB per initrd,
  # so keep 3 boot entries instead of 10 to fit the small /boot partition.
  # Overrides common/system/default.nix (grub) and mamalona (systemd-boot).
  boot.loader.grub.configurationLimit = lib.mkForce 3;
  boot.loader.systemd-boot.configurationLimit = lib.mkForce 3;

  # Full-length original audio (as-is, no trim) staged for the boot service.
  # Kept outside share/plymouth/themes so it stays in the system closure,
  # not in initrd.
  environment.etc."og-xbox-boot-audio.wav".source =
    "${themePkg}/share/og-xbox/boot-audio.wav";

  # Plymouth has no audio path in initrd (sound card isn't up yet), so this
  # best-effort service plays the clip once ALSA is alive while the splash
  # is still on screen. Fails open: a missing/muted card never blocks boot.
  systemd.services.og-xbox-boot-sound = {
    description = "Original Xbox boot animation audio";
    after = [ "sound.target" ];
    before = [ "plymouth-quit.service" ];
    wantedBy = [ "sound.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.alsa-utils}/bin/aplay -q /etc/og-xbox-boot-audio.wav";
      RemainAfterExit = false;
      StandardOutput = "null";
      StandardError = "journal";
    };
  };
}
