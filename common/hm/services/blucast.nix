{ pkgs, lib, config, ... }:

let
  cfg = config.services.blucast;
in
{
  options.services.blucast = {
    enable = lib.mkEnableOption "BluCast virtual camera service";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      lsof
      docker
    ];

    xdg.desktopEntries.blucast = {
      name = "BluCast";
      comment = "AI-Powered Virtual Camera";
      exec = "/home/juan_ma7u7/.local/bin/blucast";
      icon = "camera-video";
      terminal = false;
      categories = [ "Video" "AudioVideo" ];
    };

    home.file = {
      ".local/share/blucast/run.sh" = {
        executable = true;
        text = ''
          #!${pkgs.bash}/bin/bash
          set -eo pipefail

          GHCR_IMAGE="ghcr.io/andrei9383/blucast:latest"
          VCAM_DEVICE="/dev/video10"
          SHARED_DIR="/tmp/blucast"
          USER_HOME="$HOME"

          if ! command -v docker &>/dev/null; then
            echo "Error: docker required"; exit 1
          fi

          if [ ! -e "$VCAM_DEVICE" ]; then
            echo "Loading virtual camera module..."
            sudo modprobe v4l2loopback devices=1 video_nr=10 \
              card_label="BluCast Virtual Camera" exclusive_caps=1 \
              max_buffers=2 max_openers=10 2>/dev/null || \
              pkexec modprobe v4l2loopback devices=1 video_nr=10 \
              card_label="BluCast Virtual Camera" exclusive_caps=1 \
              max_buffers=2 max_openers=10
            sleep 1
          fi

          [ -e "$VCAM_DEVICE" ] || { echo "Error: $VCAM_DEVICE not found"; exit 1; }

          sudo chmod 666 "$VCAM_DEVICE" 2>/dev/null || chmod 666 "$VCAM_DEVICE" 2>/dev/null || true
          sudo udevadm trigger --action=change "$VCAM_DEVICE" 2>/dev/null || true

          for svc in wireplumber.service xdg-desktop-portal.service \
                     xdg-desktop-portal-gtk.service xdg-desktop-portal-gnome.service; do
            systemctl --user restart "$svc" 2>/dev/null || true
          done
          sleep 2

          mkdir -p "$SHARED_DIR"
          echo "0" > "$SHARED_DIR/consumers"
          rm -f "$SHARED_DIR/preview.jpg" "$SHARED_DIR/cmd.pipe"

          xhost +si:localuser:root 2>/dev/null || xhost +local: 2>/dev/null || true

          USER_XAUTH="$HOME/.Xauthority"
          CONTAINER_XAUTH="/tmp/blucast/.xauthority"
          [ -f "$USER_XAUTH" ] && cp "$USER_XAUTH" "$CONTAINER_XAUTH"

          docker run --rm \
            --user "$(id -u):$(id -g)" \
            --security-opt label=disable \
            --gpus all \
            -e DISPLAY="$DISPLAY" \
            -e XAUTHORITY="$CONTAINER_XAUTH" \
            -e WAYLAND_DISPLAY \
            -e NVIDIA_DRIVER_CAPABILITIES=all \
            -e NVIDIA_VISIBLE_DEVICES=all \
            -e QT_QPA_PLATFORM=xcb \
            -e QT_LOGGING_RULES="*.debug=false" \
            -e XDG_RUNTIME_DIR=/tmp/runtime-root \
            -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
            -v "$USER_XAUTH:$CONTAINER_XAUTH:rw" \
            -v "$USER_HOME:/host_home:ro" \
            -v "$USER_HOME/.config/blucast:/root/.config/blucast:rw" \
            -v "$SHARED_DIR:/tmp/blucast:rw" \
            -v "/dev/dri:/dev/dri" \
            -v "/run/user/$(id -u)/wayland-0:/run/user/$(id -u)/wayland-0:ro" \
            --ipc=host \
            --network host \
            --device /dev/video10:/dev/video10 \
            "$GHCR_IMAGE" 2>&1
        '';
      };

      ".local/bin/blucast" = {
        executable = true;
        text = ''
          #!${pkgs.bash}/bin/bash
          exec "$HOME/.local/share/blucast/run.sh" "$@"
        '';
      };
    };
  };
}
