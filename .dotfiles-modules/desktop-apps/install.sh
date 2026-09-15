# Desktop

current_user=$(whoami)

as_root <<_
apt-get install \
  libreoffice \
  vlc \
  cheese \
  gimp \
  inkscape \
  obs-studio \
  audacity \
  handbrake \
  shotcut; \
\
declare -A debs; \
debs["vscode"]="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"; \
\
for app in \"\${!debs[@]}\"; \
do \
  src=\"\${debs[\${app}]}\"; \
\
  wget -q -O \$app \$src; \
  dpkg -i \$app; \
  rm -f \$app; \
done; \
\
su $current_user -lc "code --install-extension ms-vscode-remote.remote-ssh formulahendry.code-runner vscodevim.vim"; \
\
repo_url=https://github.com/thecodingjames/peek; \
latest_release=$(wget -Sq $repo_url/releases/latest 2>&1 | grep Location: | awk -F '/' '{print $NF}'); \
download_url="${repo_url}/releases/download/${latest_release}/peek_${latest_release:1}_amd64.deb"; \
\
wget -O /tmp/peek.deb $download_url; \
apt -y install /tmp/peek.deb; \
rm /tmp/peek.deb;
_
