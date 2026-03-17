git config --global core.editor "vim"

git config --global --replace-all alias.statuses "! find . -maxdepth 1 -mindepth 1 -type d -exec sh -c '(echo {} && cd {} && git status -s && echo)' \;"
git config --global --replace-all alias.done '! f() { git commit -am "$1" && git push; }; f'
git config --global --replace-all alias.alldone '! f() { git add -A && git done "$1"; }; f'
