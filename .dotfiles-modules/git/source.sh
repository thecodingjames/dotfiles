here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source $here/completion.sh
source $here/prompt.sh

BLACK="\[\033[0;30m\]"
MAGENTA="\[\033[0;35m\]"
YELLOW="\[\033[0;33m\]"
BLUE="\[\033[34m\]"
DARK_GRAY="\[\033[1;90m\]"
CYAN="\[\033[0;36m\]"
GREEN="\[\033[0;32m\]"
GIT_PS1_SHOWDIRTYSTATE=true
export LS_OPTIONS='--color=auto'
export CLICOLOR='Yes'
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

git_ps1() {
  echo $BLACK'$(
    git_status=$(__git_ps1) 
    if [[ git_status =~ \*\)$ ]]
    # a file has been modified but not added
    then echo "'$YELLOW'"$(__git_ps1 "(%s)")
    elif [[ git_status =~ \+\)$ ]]
    # a file has been added, but not commited
    then echo "'$MAGENTA'"$(__git_ps1 "(%s)")
    # the state is clean, changes are commited
    else echo "'$CYAN'"$(__git_ps1 "(%s)")
    fi)'
}

if ! [[ $PS1 =~ __git_ps1 ]]; then
  export PS1="${PS1}$(git_ps1) $BLACK"
fi
