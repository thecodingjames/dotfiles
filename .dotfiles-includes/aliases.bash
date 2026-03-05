dotfiles() {
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME $@
}

alias cd-repos="cd $HOME/Documents/Repos"

alias pb-copy="xclip -sel clip"
alias pb-paste="xclip -out -sel clip"

alias bsync="browser-sync start --server --files "$1""
