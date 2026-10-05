#!/run/current-system/sw/bin/sh

sudo echo "Rebuilding system 🗿"

if [ "$1" != "-s" ]; then
    sudo echo "removing *.nixbak files"
    sudo find ~/ -name "*.nixbak" -type f -delete
fi

# --impure: allows the gitignored local assets/boot.webm (og-xbox
# Plymouth theme, not committed to this public repo) via absolute path.
sudo nixos-rebuild switch --flake .#thinkpad-l15 --impure

./common-rebuild-commands.sh "Thinkpad-L15"
