# Desktop

as_root <<'_'
printf "APT install...\n"; \
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
  trimage; \
\
declare -A debs; \
debs["vscode"]="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"; \
debs["insomnia"]="https://updates.insomnia.rest/downloads/ubuntu/latest?&app=com.insomnia.app&source=website"; \
debs["virtualbox"]="https://download.virtualbox.org/virtualbox/7.2.6/virtualbox-7.2_7.2.6-172322~Debian~trixie_amd64.deb"; \
\
printf "Custom debs install...\n"; \
for app in "${!debs[@]}"; \
do \
  src="${debs[${app}]}"; \
\
  wget -q -O $app $src; \
  dpkg -i $app || apt-get -qq -y -f install $app; \
  rm -f $app; \
done; 
_
