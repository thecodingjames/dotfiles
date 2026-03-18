as_root <<_
  apt-get -qq -y install \
    php php-cli \
    php-pear php-zip php-curl php-xml php-xmlrpc php-gd php-mysql php-mbstring; \
\
  curl -sS https://getcomposer.org/installer -o composer-setup.php; \
  php composer-setup.php --install-dir=/usr/local/bin --filename=composer; \
  rm composer-setup.php;
_
