here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source $here/completion.sh
source $here/prompt.sh

BLACK="\[\033[0;30m\]"
MAGENTA="\[\033[0;35m\]"
YELLOW="\[\033[0;33m\]"
BLUE="\[\033[34m\]"
DARK_GRAY="\[\033[0;90m\]"
CYAN="\[\033[0;36m\]"
GREEN="\[\033[0;32m\]"

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM="verbose"

export LS_OPTIONS='--color=auto'
export CLICOLOR='Yes'
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

git_ps1() {
  echo $BLACK'$(
    git_status=$(__git_ps1 "(%s)")
    if [[ "$git_status" =~ % ]]; then
      # a file has been added
      color="'$GREEN'"
    elif [[ "$git_status" =~ \* ]]; then
      # a file has been modified
      color="'$YELLOW'"
    elif [[ "$git_status" =~ \+ ]]; then
      # a file has been added, but not commited
      color="'$MAGENTA'"
    else
      # the state is clean, changes are commited
      color="'$DARK_GRAY'"
    fi
    git_status="${git_status//u/}"
    git_status="${git_status//\*/\*}"
    echo -n $color$git_status
    # Padding
    [[ -n $git_status ]] && echo -n " "
  )'
}

export DOTFILES_GIT_PS1='${PS1}$(git_ps1)$BLACK'

if ! [[ "$PS1" =~ __git_ps1 ]]; then
  export PS1="$(eval "echo \"${DOTFILES_GIT_PS1}\"") "
fi
