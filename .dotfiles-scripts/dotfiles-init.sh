#! /bin/bash
# https://www.atlassian.com/git/tutorials/dotfiles

echo "Dotfiles init..."

gitDir="$HOME/.dotfiles"
dotfiles() {
    git --git-dir=$gitDir --work-tree=$HOME $@
}

rm -rf $gitDir

git clone --bare https://jameshoffman@bitbucket.org/jameshoffman/dotfiles.git $gitDir

backupPath="$HOME/.dotfiles-backup-$(date +"%d-%m-%Y_%Hh%Mm%S")"
mkdir -p $backupPath

dotfiles checkout

if [ $? != 0 ]; then
    echo "Moving existing dotfiles to $backupPath";

    dotfiles checkout 2>&1 | egrep '\s+\S*\.\S+' | awk {'print $1'} | xargs -I{} bash -c 'mkdir -p $2/`dirname $1` && mv $HOME/$1 "$2/"$1' bashParams {} $backupPath
    # https://stackoverflow.com/questions/6958689/running-multiple-commands-with-xargs/51305211#comment97788770_51305211
fi;

dotfiles checkout

echo -e  "\nYou should probably restart your terminal :)"