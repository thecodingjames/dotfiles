current_user=$(whoami)

as_root <<_
  apt-get install nodejs npm; \
\
  echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.conf && sysctl -p; \
\
  su $current_user -lc "mkdir -p ~/.npm-global/lib; npm config set prefix '~/.npm-global'";
_
