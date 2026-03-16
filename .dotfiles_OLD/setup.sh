#!/bin/bash

echo "System Setup"

###
### Basic tools
###

read -r -d '' ROOTCMD <<ASROOT
		
	# Custom PPAs
    apt -q -y install python3-launchpadlib


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
