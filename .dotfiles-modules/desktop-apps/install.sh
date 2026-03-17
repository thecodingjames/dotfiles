# Desktop

current_user=$(whoami)

as_root <<_
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
  insomnia ;\
\
declare -A debs; \
debs["vscode"]="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"; \
\
for app in \"\${!debs[@]}\"; \
do \
  src=\"\${debs[\${app}]}\"; \
\
  wget -q -O \$app \$src; \
  dpkg -i \$app > /dev/null; \
  rm -f \$app; \
done; \
\
su $current_user -lc "code --install-extension ms-vscode-remote.remote-ssh formulahendry.code-runner vscodevim.vim > /dev/null";
_
