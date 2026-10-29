{ pkgs, ... }:
let
  replayScript = pkgs.writeShellScript "gpu-screen-recorder-replay" ''
    mkdir -p "$HOME/Videos/Clips"
    exec ${pkgs.gpu-screen-recorder}/bin/gpu-screen-recorder \
      -w portal \
      -restore-portal-session yes \
      -f 60 \
      -a default_output \
      -c mp4 \
      -r 60 \
      -bm cbr \
      -q 40000 \
      -o "$HOME/Videos/Clips"
  '';
in
{
  imports = [
    ./host.nix
  ];

  # Started from mamalona's Hyprland startup hook after importing the Wayland
  # session environment. The first portal capture may require user approval.
  systemd.user.services.gpu-screen-recorder-replay = {
    Unit = {
      Description = "GPU Screen Recorder 60-second replay buffer";
    };

    Service = {
      ExecStart = "${replayScript}";
      KillSignal = "SIGINT";
      TimeoutStopSec = "15s";
    };
  };
}
