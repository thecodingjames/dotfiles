export EDITOR=vim
export PROMPT_DIRTRIM=3

export REPOS="$HOME/Documents/Repos"
alias cdr="cd $REPOS"

alias pbc="xclip -sel clip"
alias pbp="xclip -out -sel clip"

eval "$(fzf --bash)"
