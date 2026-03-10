#! /bin/bash

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source $HERE/../.dotfiles-modules/dotfiles.sh

echo "Dotfiles init..."

if [ -d "$DOTFILES_GIT_DIR" ]; then
  echo "Dotfiles directory found"
else
  echo "Cloning repo"
  git clone --bare $REPO_URL $DOTFILES_GIT_DIR
fi

echo "Pulling repo..."
CHANGED_FILES=$(dotfiles pull &>/dev/null && dotfiles checkout)

if [ -n "$CHANGED_FILES" ]; then
  BACKUP_PATH="$HOME/.dotfiles-backup-$(date +"%d-%m-%Y_%Hh%Mm%S")"
  mkdir -p $BACKUP_PATH

  echo "Moving existing dotfiles to $BACKUP_PATH";

  echo $CHANGED_FILES | egrep '\s+\S*\.\S+' | awk {'print $2'} | xargs -I{} bash -c 'mkdir -p $2/`dirname $1` && cp $HOME/$1 "$2/"$1' bashParams {} $BACKUP_PATH
    # https://stackoverflow.com/questions/6958689/running-multiple-commands-with-xargs/51305211#comment97788770_51305211
    dotfiles checkout -f
fi;

echo -e  "\nYou should probably restart your terminal :)"
