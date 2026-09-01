if [ -e ~/.vimrc ]; then
  mv ~/.vimrc ~/.vimrc-backup-$(date +"%d-%m-%Y_%Hh%Mm%S") 
fi

as_root <<_
apt-get install \
  vim \
  tmux \
  fzf \
  curl \
  tree \
  zip \
  unzip
_
