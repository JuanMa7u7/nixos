{ pkgs, lib, ... }:
{
  # Explicit audio stack (both hosts). Previously PipeWire worked only
  # transitively (no declaration in repo); RTKit was off, causing
  # `RTKit error: ServiceUnknown` in pipewire/wireplumber logs, and the
  # Logitech G733 (ALSA card "Headset", USB 046d:0ab5) sat at PCM 77%
  # (-15dB) while PipeWire showed 100%.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = false;
    wireplumber.enable = true;
  };
  services.pulseaudio.enable = false;

  # Logitech G733 (USB 046d:0ab5) hardening. Two separate rules because the
  # ALSA monitor applies `monitor.alsa.rules` to the card *device* and to each
  # PCM *node* independently (device properties do not propagate to nodes):
  #  - device rule: pin the standard "output:analog-stereo+input:mono-fallback"
  #    profile. WirePlumber skips "pro-audio" during auto-selection; the pinned
  #    pro-audio came from stale state in ~/.local/state/wireplumber.
  #  - node rule: keep the wireless sink from suspending on idle and enlarge the
  #    ALSA headroom so USB isochronous underruns are absorbed.
  services.pipewire.wireplumber.extraConfig."51-logitech-g733" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          { "device.name" = "~alsa_card.*Logitech_G733.*"; }
        ];
        actions.update-props = {
          "device.profile" = "output:analog-stereo+input:mono-fallback";
        };
      }
      {
        matches = [
          { "node.name" = "~alsa_.*Logitech_G733.*"; }
        ];
        actions.update-props = {
          "session.suspend-timeout-seconds" = 0;
          "api.alsa.headroom" = 8192;
          "api.alsa.period-size" = 1024;
        };
      }
    ];
  };

  security.rtkit.enable = true;

  # Persist ALSA mixer state across reboots (alsactl store/restore).
  hardware.alsa.enablePersistence = true;

  # Debug tools: amixer/alsamixer/alsactl. pavucontrol stays in
  # home-manager (common/hm/packages/desktop.nix) — do not duplicate here.
  environment.systemPackages = with pkgs; [ alsa-utils ];

  # G733 restore on USB re-plug: trigger the one-shot below via systemd.
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="sound", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="0ab5", TAG+="systemd", ENV{SYSTEMD_WANTS}="g733-alsa-restore.service"
  '';

  # G733 ALSA restore on boot (and on re-plug via udev above).
  # Uses card name "Headset" (stable; numeric index moves). Guarded so
  # hosts without the headset (thinkpad-l15) never fail the boot.
  systemd.services.g733-alsa-restore = {
    description = "Restore Logitech G733 ALSA PCM to 100% (0dB)";
    wantedBy = [ "sound.target" ];
    after = [ "sound.target" ];
    unitConfig.ConditionPathExists = "/proc/asound/Headset";
    serviceConfig.Type = "oneshot";
    script = ''
      # Wait briefly for the ALSA mixer control to appear after plug/boot.
      for i in 1 2 3 4 5 6 7 8 9 10; do
        ${pkgs.alsa-utils}/bin/amixer -c Headset get PCM >/dev/null 2>&1 && break
        ${pkgs.coreutils}/bin/sleep 0.5
      done
      ${pkgs.alsa-utils}/bin/amixer -c Headset set PCM 100% || true
    '';
  };
}
