ruby_install=$(wget -Sq -O- https://github.com/postmodern/ruby-install/releases/latest 2>&1 | grep Location: | awk -F '/v' '{print $NF}')

as_root <<_
  apt-get install make; \
\
  wget -q -O /tmp/ruby-install.tar.gz https://github.com/postmodern/ruby-install/releases/download/v$ruby_install/ruby-install-${ruby_install}.tar.gz ; \
  cd /tmp && tar -xzf ruby-install.tar.gz; \
  cd /tmp/ruby-install-${ruby_install}/ && make install; \
  rm -rf /tmp/ruby-install-${ruby_install}; \
\
  ruby-install --system ruby >/dev/null;
_
	
