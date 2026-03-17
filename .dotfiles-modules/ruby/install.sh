ruby_install='0.10.2'

as_root <<_
  apt-get -qq -y install make; \
\
  wget -q -O /tmp/ruby-install.tar.gz https://github.com/postmodern/ruby-install/releases/download/v$ruby_install/ruby-install-${ruby_install}.tar.gz ; \
  cd /tmp && tar -xzvf ruby-install.tar.gz > /dev/null; \
  cd /tmp/ruby-install-${ruby_install}/ && make install; \
  rm -rf /tmp/ruby-install-${ruby_install}; \
\
  ruby-install --system ruby;
_
	
