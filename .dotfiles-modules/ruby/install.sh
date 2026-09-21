ruby_install=$(wget -Sq -O- https://github.com/postmodern/ruby-install/releases/latest 2>&1 | grep Location: | awk -F '/v' '{print $NF}')
chruby=$(wget -Sq -O- https://github.com/postmodern/chruby/releases/latest 2>&1 | grep Location: | awk -F '/v' '{print $NF}')

as_root <<_
  apt-get install make; \
\
  wget -q -O /tmp/ruby-install.tar.gz https://github.com/postmodern/ruby-install/releases/download/v$ruby_install/ruby-install-${ruby_install}.tar.gz ; \
  cd /tmp && tar -xzf ruby-install.tar.gz; \
  cd /tmp/ruby-install-${ruby_install}/ && make install; \
  rm -rf /tmp/ruby-install-${ruby_install} /tmp/ruby-install.tar.gz; \
\
  ruby-install --system ruby >/dev/null; \
\
  wget -q -O /tmp/chruby.tar.gz https://github.com/postmodern/chruby/releases/download/v$chruby/chruby-${chruby}.tar.gz ; \
  cd /tmp && tar -xzf chruby.tar.gz; \
  cd /tmp/chruby-${chruby}/ && make install; \
  rm -rf /tmp/chruby-${chruby} /tmp/chruby.tar.gz;
_
