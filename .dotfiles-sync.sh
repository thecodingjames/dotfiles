#! /bin/bash

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Keep lines below in sync with 
# ./.dotfiles-modules/dotfiles/source.sh
REPO_URL=https://github.com/thecodingjames/dotfiles.git
DOTFILES_GIT_DIR="$HOME/.dotfiles"

dotfiles() {
    git --git-dir=$DOTFILES_GIT_DIR --work-tree=$HOME $@
}
#
# END

echo "============="
echo "DOTFILES SYNC"
echo "============="

if [ -d "$DOTFILES_GIT_DIR" ]; then
  echo "Dotfiles directory found"
else
  echo "Cloning repo"

  git clone --bare $REPO_URL $DOTFILES_GIT_DIR
  dotfiles config --local status.showUntrackedFiles no
fi

echo "Pulling repo..."
changed_files=$(dotfiles pull &>/dev/null && dotfiles checkout)

if [ -n "$changed_files" ]; then
  backup_path="$HOME/.dotfiles-backup-$(date +"%d-%m-%Y_%Hh%Mm%S")"
  mkdir -p $backup_path

  echo "Moving existing dotfiles to $backup_path";

  echo $changed_files | egrep '\s+\S*\.\S+' | awk {'print $2'} | xargs -I{} bash -c 'mkdir -p $2/`dirname $1` && cp $HOME/$1 "$2/"$1' bashParams {} $backup_path
    # https://stackoverflow.com/questions/6958689/running-multiple-commands-with-xargs/51305211#comment97788770_51305211
    dotfiles checkout -f
fi;
