here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

extensions_destination="$HOME"/.local/share/gnome-shell/extensions/

mkdir -p $extensions_destination

cp -r "$here"/extensions/* $extensions_destination

as_root 'apt-get -y install gnome-shell-extension-manager'

dconf write /org/gnome/shell/enabled-extensions "['hide-panel-lite@thecodingjames', 'launch-new-instance@thecodingjames']"

dconf write /org/gnome/desktop/input-sources/sources "[('xkb', 'us'), ('xkb', 'ca')]"
dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']"

dconf write /org/gnome/desktop/interface/enable-hot-corners "false"
dconf write /org/gnome/shell/favorite-apps "['']"

dconf write /org/gnome/shell/keybindings/toggle-message-tray "['']"
dconf write /org/gnome/desktop/wm/keybindings/unmaximize "['']"
dconf write /org/gnome/desktop/wm/keybindings/minimize "['']"
dconf write /org/gnome/desktop/wm/keybindings/maximize "['']"
dconf write /org/gnome/desktop/wm/keybindings/toggle-maximized "['<Super>m']"

gsettings set org.freedesktop.ibus.panel.emoji hotkey "['']"
dconf write /org/gnome/desktop/wm/keybindings/close "['<Super>period']"

dconf write /org/gnome/desktop/wm/keybindings/switch-windows "['<Shift>Escape']"
gsettings set org.gnome.shell.window-switcher current-workspace-only true

dconf write /org/gnome/settings-daemon/plugins/media-keys/screensaver "['<Shift><Control>Escape']"

dconf write /org/gnome/mutter/keybindings/toggle-tiled-left "['<Super>h']"
dconf write /org/gnome/mutter/keybindings/toggle-tiled-right "['<Super>l']"

dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-left "['<Super>k']"
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-right "['<Super>j']"

dconf write /org/gnome/desktop/wm/keybindings/move-to-monitor-left "['<Super>Left']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-monitor-right "['<Super>Right']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-monitor-up "['<Super>Up']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-monitor-down "['<Super>Down']"


# Disable suspend on AC Power
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0
# Suspend after 10 minutes on battery
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 600
# Dim display after 15 minutes
gsettings set org.gnome.desktop.session idle-delay 900
# Disable dim when idle
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
# Disable auto-brightness
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
# Show battery percentage
gsettings set org.gnome.desktop.interface show-battery-percentage true
# Show weekday beside clock
gsettings set org.gnome.desktop.interface clock-show-weekday true
# Disable notifications on lockscreen
gsettings set org.gnome.desktop.notifications show-in-lock-screen false
# Detach modals form windows
gsettings set org.gnome.mutter attach-modal-dialogs false
# Shot Desktop shorcut in file manager
gsettings set org.gnome.desktop.background show-desktop-icons true
# Sort folders before files in File Explorer
gsettings set org.gtk.Settings.FileChooser sort-directories-first true
# Use list view
gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
# Enable tree-view to expand folders
gsettings set org.gnome.nautilus.list-view use-tree-view true
# Columns to show in list view
gsettings set org.gnome.nautilus.list-view default-visible-columns "['name', 'size', 'date_modified']"

gsettings set org.gnome.desktop.background primary-color "black"

# Disable default Places
mkdir -p $HOME/.config/
echo "enabled=false" > $HOME/.config/user-dirs.conf

# Remove unwanted bookmarks added by default
mkdir -p $HOME/.config/gtk-3.0
echo "" > ~/.config/gtk-3.0/bookmarks

custom_desktop_apps_destination=$HOME/.local/share/applications
mkdir -p $custom_desktop_apps_destination

for entry in $here/desktop-entries/*; do
  cp $entry "$custom_desktop_apps_destination/$(basename $entry)"
done
