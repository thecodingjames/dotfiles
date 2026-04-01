#! /bin/bash

dotfiles_config="$HOME/.dotfiles-config" 
touch $dotfiles_config

if [[ -f "$dotfiles_config" ]]; then
  source "$dotfiles_config"
  # provides $config_source
fi

repo_url=https://github.com/thecodingjames/dotfiles
git_dir="$HOME/.dotfiles"
tar_file="$HOME/dotfiles.tar.gz"

# BEGIN
# Keep function below in sync with 
# .dotfiles-modules/dotfiles/source.sh
#
dotfiles() {
    git --git-dir="$HOME/.dotfiles" --work-tree=$HOME $@
}
#
# END

echo "============="
echo "DOTFILES SYNC"
echo "============="

pull() {
  changed_files=$(dotfiles pull &>/dev/null && dotfiles checkout 2>&1)

  echo "$changed_files" | grep -E '^M?\s+\S*\.\S+' | awk {'print $NF'}
}

download() {
  changed_files=$(tar -xk --strip-components=1 --directory=$HOME -f $tar_file 2>&1)

  echo "$changed_files" | grep -E 'File exists' | awk -F': ' {'print $2'}
}

backup() {
  read -d '' existing_files

  if [ -n "$existing_files" ]; then
    backup_path="$HOME/.dotfiles-backup-$(date +"%d-%m-%Y_%Hh%Mm%S")"
    mkdir -p $backup_path

    echo "Moving existing dotfiles to $backup_path";

    for file in $existing_files; do
      mkdir -p "$backup_path/$(dirname $file)"
      cp "$HOME/$file" "$backup_path/$file"
    done
  fi;
}

config_source="${config_source:-'git'}"
sync_source="${SOURCE:-$config_source}"

if [[ $sync_source =~ 'git' ]]; then
  if ! [[ -d $git_dir ]]; then
    git clone --bare "$repo_url.git" $git_dir
    dotfiles config --local status.showUntrackedFiles no
  fi

  echo ""
  echo "Pulling repo..."

  pull | backup

  dotfiles checkout -f
elif [[ $sync_source =~ 'archive' ]]; then
  echo ""
  echo "Downloading archive..."

  latest_release=$(wget -Sq $repo_url/releases/latest 2>&1 | grep Location: | awk -F '/' '{print $NF}')
  wget -qO dotfiles.tar.gz "$repo_url/archive/refs/tags/$latest_release.tar.gz"

  download | backup

  tar -x --strip-components=1 --directory=$HOME -f $tar_file
  rm $tar_file
else
  echo "Invalid source: $sync_source"
  exit 0
fi

echo ""
echo "Sync done!"

source $HOME/.bashrc

config_source="config_source='$sync_source'"

if grep -Fq "config_source" $dotfiles_config; then
  sed -i "/config_source/s/^.*$/$config_source/" "$dotfiles_config"
else
  echo "$config_source" >> "$dotfiles_config"
fi
