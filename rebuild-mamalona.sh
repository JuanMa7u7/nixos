#!/run/current-system/sw/bin/sh

sudo echo "Rebuilding system 🗿"

if [ "$1" != "-s" ]; then
    sudo echo "removing *.nixbak files"
    sudo find ~/ -name "*.nixbak" -type f -delete
fi

# The tracked assets/boot.webm is referenced relative to the flake root.
# It is Microsoft IP and retained here for local personal use.
sudo nixos-rebuild switch --flake .#mamalona

./common-rebuild-commands.sh "Mamalona"
