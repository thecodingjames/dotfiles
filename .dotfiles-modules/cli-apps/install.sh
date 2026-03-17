# CLI

uname=$(uname -r)

as_root <<_ 
apt-get -qq -y install \
  exfat-fuse \
  unrar-free \
  xclip \
  httpie \
  glances \
  ffmpeg \
  handbrake-cli \
  make \
  build-essential \
  dpkg-dev \
  linux-headers-amd64 \
  linux-headers-$uname \
  ufw
_
