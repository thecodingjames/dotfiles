here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

read -r -d '' STARTUPBUTTONS <<_
[Desktop Entry]
Name=wacom-buttons
Exec="$here/.dotfiles-modules/wacom/buttons.sh"
Type=Application
_

echo "$STARTUPBUTTONS" > $HOME/.config/autostart/wacom.desktop
