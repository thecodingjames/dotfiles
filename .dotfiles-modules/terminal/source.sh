export EDITOR=vim
export PROMPT_DIRTRIM=3

BLACK="\[\033[0;30m\]"
BOLD_DARK_GRAY="\[\033[1;90m\]"

prompt="$BOLD_DARK_GRAY\w/ \$(
  theme=\$(gsettings get org.gnome.desktop.interface color-scheme)
  if [[ \$theme =~ 'prefer-dark' ]]; then
    echo '$WHITE'
  else
    echo '$BLACK'
  fi
)"

if [[ $PS1 =~ __git_ps1 ]]; then
  # Make prompt handle dependency from git modules prompt
  export PS1=$( eval "echo \"${DOTFILES_GIT_PS1/'${PS1}'/"$prompt"}\"" )
else
  export PS1="$prompt"
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

export REPOS="$HOME/Repos"
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
