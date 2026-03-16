export EDITOR=vim
export PROMPT_DIRTRIM=3

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

export REPOS="$HOME/Documents/Repos"
mkdir -p "$REPOS"

alias cdr="cd $REPOS"

eval "$(fzf --bash)"

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$here"/prj.sh
