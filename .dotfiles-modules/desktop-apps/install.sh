# Desktop

as_root <<'_'
apt-get -qq -y install \
  libreoffice \
  vlc \
  cheese \
  gimp \
  inkscape \
  obs-studio \
  audacity \
  handbrake \
  shotcut \
  trimage \
  libqt6core6t64 \
  libqt6dbus6 \
  libqt6gui6 \
  libqt6help6 \
  libqt6printsupport6 \
  libqt6statemachine6 \
  libqt6widgets6 \
  libqt6xml6; \
\
declare -A debs; \
debs["vscode"]="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"; \
debs["insomnia"]="https://updates.insomnia.rest/downloads/ubuntu/latest?&app=com.insomnia.app&source=website"; \
debs["virtualbox"]="https://download.virtualbox.org/virtualbox/7.2.6/virtualbox-7.2_7.2.6-172322~Debian~trixie_amd64.deb"; \
\
for app in "${!debs[@]}"; \
do \
  src="${debs[${app}]}"; \
\
  wget -q -O $app $src; \
  $(dpkg -i $app || apt-get -qq -y -f install $app) > /dev/null; \
  rm -f $app; \
done; \
\
su $current_user -lc 'code --install-extension ms-vscode-remote.remote-ssh formulahendry.code-runner vscodevim.vim';
_
