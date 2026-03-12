#!/bin/bash

echo "System Setup"

###
### Basic tools
###

read -r -d '' ROOTCMD <<ASROOT
	apt -q update && apt -q -y upgrade

    apt -q -y install \
		exfat-fuse \
		unrar-free \
		curl \
		make \
		httpie \
		glances \
		ufw \
		libreoffice \
		ksnip \
		kolourpaint \
		vlc \
		cheese \
		gimp \
		audacity \
		handbrake \
		shotcut \
		trimage \
		ffmpeg \
		build-essential \
        linux-headers-amd64 \
        linux-headers-$(uname -r)
		
	ufw enable

	# Custom PPAs
    apt -q -y install python3-launchpadlib
	add-apt-repository -y \
        ppa:peek-developers/stable \
        ppa:obsproject/obs-studio \
        ppa:inkscape.dev/stable

	apt -q update

	apt -q -y install \
        peek \
        obs-studio \
        inkscape

    declare -A debs
    debs['vscode']='https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
    debs['discord']='https://discord.com/api/download?platform=linux&format=deb'
    debs['insomnia']='https://updates.insomnia.rest/downloads/ubuntu/latest?&app=com.insomnia.app&source=website'
    debs['virtualbox']='https://download.virtualbox.org/virtualbox/7.0.14/virtualbox-7.0_7.0.14-161095~Debian~bookworm_amd64.deb'

	for app in "\${!debs[@]}";
	do
		src="\${debs[\${app}]}"

		wget -O \$app \$src
		dpkg -i \$app 
		rm \$app
	done

    #
	# PHP
    #
	apt -q -y install php php-cli
	apt -q -y install php-pear php-zip php-curl php-xml php-xmlrpc php-gd php-mysql php-mbstring

	curl -sS https://getcomposer.org/installer -o composer-setup.php
	php composer-setup.php --install-dir=/usr/local/bin --filename=composer
	rm composer-setup.php

    #
    # Node
    #
	apt -q -y install \
        nodejs \
        npm \
        ;

	npm install -g browser-sync
    echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.conf && sysctl -p
	# See ../.dotfiles-includes/variables.bash for updated PATH variable
	
    #
    # Ruby
    #
	apt -q -y install \
        ruby \
        bundler \
        ;
		
	# See ../.dotfiles-includes/variables.bash for updated PATH variable

    apt -q -y --fix-broken install

ASROOT

su - -c "$ROOTCMD"

mkdir -p ~/.npm-global/lib
npm config set prefix '~/.npm-global'


#
# VS Code Extensions
#

code --install-extension ms-vscode-remote.remote-ssh
code --install-extension formulahendry.code-runner
code --install-extension vscodevim.vim 


#
# Git config
#

mkdir -p "$HOME/Documents/Repos"

git config --global user.name "James Hoffman"
git config --global user.email james-hoffman@live.ca
git config --global core.editor "vim"

git config --global --replace-all alias.statuses "! find . -maxdepth 1 -mindepth 1 -type d -exec sh -c '(echo {} && cd {} && git status -s && echo)' \;"
git config --global --replace-all alias.done '! f() { git commit -am "$1" && git push; }; f'
git config --global --replace-all alias.alldone '! f() { git add -A && git done "$1"; }; f'

#
# Generate RSA key-pair
#

ssh-keygen -f ~/.ssh/id_rsa -P ""
eval `ssh-agent`
ssh-add ~/.ssh/id_rsa

#
# UI Tweaks
#

cp -r $HOME/.dotfiles-gnome-extensions/* $HOME/.local/share/gnome-shell/extensions/

dconf write /org/gnome/shell/enabled-extensions "['launch-new-instance@gnome-shell-extensions.gcampax.github.com']"

dconf write /org/gnome/desktop/input-sources/sources "[('xkb', 'us'), ('xkb', 'ca')]"
dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']"

dconf write /org/gnome/desktop/interface/enable-hot-corners "false"
dconf write /org/gnome/shell/favorite-apps "['']"

dconf write /org/gnome/shell/keybindings/toggle-message-tray "['']"
dconf write /org/gnome/desktop/wm/keybindings/unmaximize "['']"
dconf write /org/gnome/desktop/wm/keybindings/minimize "['']"
dconf write /org/gnome/desktop/wm/keybindings/maximize "['']"
dconf write /org/gnome/desktop/wm/keybindings/toggle-maximized "['<Super>m']"

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

# Disable default Places
echo "enabled=false" > ~/.config/user-dirs.conf

# Remove unwanted bookmarks added by default
echo "" > ~/.config/gtk-3.0/bookmarks

read -r -d '' OFFF << EOOFFF
[Desktop Entry]
Name=Offf
GenericName=Turn off
Exec=systemctl poweroff
Type=Application
Categories=Utility
Terminal=false
EOOFFF

echo "$OFFF" > $HOME/.local/share/applications/offf.desktop

read -r -d '' STARTUPBUTTONS << EOSTARTUPBUTTONS
[Desktop Entry]
Name=wacom-buttons
Exec="$HOME/.dotfiles-scripts/wacom-buttons.sh"
Type=Application
EOSTARTUPBUTTONS

echo "$STARTUPBUTTONS" > $HOME/.config/autostart/wacom.desktop


#
# Wrap-up
#

echo -e "\n===============\n"
echo -e "Done!\n"

read -p "Reboot now? (y/n)" answer
if [ "$answer" = "y" ]; then
    su - -c "systemctl reboot"
fi
