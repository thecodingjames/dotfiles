as_root <<'_'
apt-get install \
  linux-headers-$(uname -r) \
  dkms \
  libvpx-dev \
  libqt6core6t64 \
  libqt6dbus6 \
  libqt6gui6 \
  libqt6help6 \
  libqt6printsupport6 \
  libqt6statemachine6 \
  libqt6widgets6 \
  libqt6xml6 \
  vagrant; \
\
virtualbox_url="https://download.virtualbox.org/virtualbox/7.2.6/virtualbox-7.2_7.2.6-172322~Debian~trixie_amd64.deb"; \
\
wget -q -O /tmp/vbox $virtualbox_url; \
dpkg -i /tmp/vbox; \
rm -f /tmp/vbox; \
\
/sbin/vboxconfig;
_
