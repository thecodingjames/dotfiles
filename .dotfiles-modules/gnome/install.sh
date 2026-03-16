here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

destination="$HOME"/.local/share/gnome-shell/extensions/

mkdir -p $destination

cp -r "$here"/extensions/* $destination

as_root 'apt-get -qq -y install gnome-shell-extension-manager'

dconf write /org/gnome/shell/enabled-extensions "['hide-panel-lite@thecodingjames', 'launch-new-instance@thecodingjames']"
