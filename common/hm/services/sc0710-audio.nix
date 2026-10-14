{ pkgs, lib, config, ... }:

let
  cfg = config.services.sc0710-audio;
in
{
  options.services.sc0710-audio = {
    enable = lib.mkEnableOption "sc0710 capture card audio routing to EasyEffects";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      pulseaudio
    ];

    home.file = {
      ".local/bin/sc0710-audio-link" = {
        executable = true;
        text = ''
          #!${pkgs.bash}/bin/bash
          set -e

          # Wait for pipewire to be ready
          sleep 3

          # Kill any existing dummy capture
          pkill -f "ffmpeg.*alsa_input.pci-0000_04_00" 2>/dev/null || true

          # Remove any existing links from sc0710
          pw-link -d "alsa_input.pci-0000_04_00.0.stereo-fallback:capture_FL" 2>/dev/null || true
          pw-link -d "alsa_input.pci-0000_04_00.0.stereo-fallback:capture_FR" 2>/dev/null || true

          # Link sc0710 capture card directly to G733 headset speakers
          # (standard analog-stereo profile; pro-output-0 AUX ports are gone)
          pw-link "alsa_input.pci-0000_04_00.0.stereo-fallback:capture_FL" "alsa_output.usb-Logitech_G733_Gaming_Headset-00.analog-stereo:playback_FL" 2>/dev/null || true
          pw-link "alsa_input.pci-0000_04_00.0.stereo-fallback:capture_FR" "alsa_output.usb-Logitech_G733_Gaming_Headset-00.analog-stereo:playback_FR" 2>/dev/null || true

          # Start ffmpeg dummy capture to keep sc0710 stream active (reads and discards)
          ffmpeg -f alsa -i hw:0 -f null - 2>/dev/null &

          # Set sc0710 volume and unmute
          wpctl set-volume 95 1.0 2>/dev/null || true
          wpctl set-mute 95 0 2>/dev/null || true
        '';
      };
    };

    systemd.user.services.sc0710-audio-link = {
      Unit = {
        Description = "Link sc0710 capture card audio to speakers";
        After = [ "pipewire.service" "wireplumber.service" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash /home/juan_ma7u7/.local/bin/sc0710-audio-link";
        RemainAfterExit = true;
      };
      Install = {
        WantedBy = [ "multi-user.target" ];
      };
    };

    xdg.desktopEntries.sc0710-audio = {
      name = "sc0710 Audio Link";
      comment = "Link sc0710 capture card audio to EasyEffects";
      exec = "${pkgs.bash}/bin/bash /home/juan_ma7u7/.local/bin/sc0710-audio-link";
      icon = "audio-card";
      terminal = true;
      categories = [ "Audio" "AudioVideo" ];
    };
  };
}
