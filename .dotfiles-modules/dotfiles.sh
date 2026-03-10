REPO_URL=https://github.com/thecodingjames/dotfiles.git
DOTFILES_GIT_DIR="$HOME/.dotfiles"

dotfiles() {
    git --git-dir=$DOTFILES_GIT_DIR --work-tree=$HOME $@
}
