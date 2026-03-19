as_root <<_
  apt-get install \
    php php-cli \
    php-pear php-zip php-curl php-xml php-xmlrpc php-gd php-mysql php-mbstring; \
\
  wget -q -O composer-setup.php https://getcomposer.org/installer; \
  php composer-setup.php --install-dir=/usr/local/bin --filename=composer; \
  rm composer-setup.php;
_
