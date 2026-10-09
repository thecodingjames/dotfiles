alias pbc="xclip -sel clip"
alias pbp="xclip -out -sel clip"

if [[ $- == *i* && -z ${TMUX:-} ]] && command -v tmux; then
  exec tmux new-session
fi
