export EDITOR=vim
export PROMPT_DIRTRIM=3

BLACK="\[\033[0;30m\]"
DARK_GRAY="\[\033[1;90m\]"

export PS1="$DARK_GRAY\w/ $BLACK"

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

export REPOS="$HOME/Documents/Repos"
mkdir -p "$REPOS"

alias cdr="cd $REPOS"

if [[ $(cat /etc/debian_version) =~ ^12 ]]; then
  # debian 12
  source /usr/share/bash-completion/completions/fzf
  source /usr/share/doc/fzf/examples/key-bindings.bash
else
  eval "$(fzf --bash)"
fi

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$here"/prj.sh
